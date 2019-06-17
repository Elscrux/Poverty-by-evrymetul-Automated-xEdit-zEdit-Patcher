unit UserScript;

uses 'lib\mxpf';

function Initialize: integer;

var
  changed: boolean;
  i, j, k, lastPercent: integer;
  currentFile, currentSignature, editorID, formID, rName, rFormID, rEditorID, rSignature, fIngredient, fEditor, lNewItem, fSignature, fFormID, lEditorID, lSignature, lFormID, cNewItem, cEditorID, cSignature, nItem, nEditorID, nSignature, tIngredient, tEditorID, tSignature, tFormID, povertyFileLoadOrder, dummyDrink, dummyFood, dummyPotion, dummyArrow, dummyAmulet, dummyBoots, dummyCirclet, dummyCuirass, dummyGauntlets, dummyHelmet, dummyRing, dummyShield, dummyBook, dummyIngredient, dummyClutter, dummyResource, dummySeptim, dummySoulGem, dummyBattleaxe, dummyBow, dummyDagger, dummyGreatSword, dummyMace, dummyStaff, dummySword, dummyWarAxe, dummyWarhammer, dummyWeapon1H, dummyWeapon2H: string;
  rec, lvliRecord, rItemRecord, ItemsListubRecord, cItem, lEntries, lEntry, nItems: IInterface;
  itemKeywords, signatures, failedFormIDs, errorFormIDs, cItemsList, cCountsList, lLevelList, lReferenceList, lCountList, blackListLVLI: TStringList;

begin
	//--------------------------------
	//MXPF Initialization
	//--------------------------------
	InitializeMXPF;
	DefaultOptionsMXPF;

	//Name this whatever you like
	PatchFileByName('Poverty All-in-One Patch.esp');

	SetInclusions('HearthFires.esm');
	//SetInclusions('Dawnguard.esm');
	//SetExclusions('Poverty.esp');

	//--------------------------------
	//Loading records
	//--------------------------------
	LoadChildRecords('CELL', 'REFR');
	//LoadChildRecords('WRLD', 'REFR');
	LoadRecords('CONT');
	LoadRecords('FLOR');
	LoadRecords('LVLI');
	LoadRecords('NPC_');
	LoadRecords('TREE');
	AddMessage('Records loaded');

	CopyRecordsToPatch;
	seev(mxPatchFile, 'CNAM', 'Evrymetul and Elscrux');
	seev(mxPatchFile, 'SNAM', 'Patch for Poverty');
	
	AddMasterIfMissing(mxPatchFile, 'Poverty.esp');

	AddMessage('Records copied to patch');

	itemKeywords := TStringList.Create;
	failedFormIDs := TStringList.Create;
	errorFormIDs := TStringList.Create;
	cItemsList := TStringList.Create;
	cCountsList := TStringList.Create;
	lLevelList := TStringList.Create;
	lReferenceList := TStringList.Create;
	lCountList := TStringList.Create;
	blackListLVLI := TStringList.Create;
	signatures := TStringList.Create;

	//--------------------------------
	//Get dummys from Skyrim & Poverty
	//--------------------------------
	povertyFileLoadOrder := IntToStr(GetLoadOrder(FileByName('Poverty.esp')));

	dummyDrink := povertyFileLoadOrder + '01A21D';
	dummyFood := povertyFileLoadOrder + '01A21E';
	dummyPotion := '6A07E';
	dummyArrow := '6A0BF';
	dummyAmulet := povertyFileLoadOrder + '014C9A';
	dummyBoots := '6A0A9';
	dummyCirclet := povertyFileLoadOrder + '019DD5';
	dummyCuirass := '6A0AB';
	dummyGauntlets := '6A0AD';
	dummyHelmet := '6A0AF';
	dummyRing := povertyFileLoadOrder + '014C99';
	dummyShield := '6A0B1';
	dummyBook := 'D7866';
	dummyIngredient := povertyFileLoadOrder + '01A017';
	dummyClutter := povertyFileLoadOrder + '01A163';
	dummyResource := povertyFileLoadOrder + '01A153';
	dummySeptim := povertyFileLoadOrder + '01A119';
	dummySoulGem := '6A0C2';
	dummyBattleaxe := '6A0BB';
	dummyBow := '6A0BD';
	dummyDagger := '20163';
	dummyGreatSword := '6A0B8';
	dummyMace := '6A0BA';
	dummyStaff := povertyFileLoadOrder + '01A116';
	dummySword := '6A0B9';
	dummyWarAxe := '6A0BC';
	dummyWarhammer := '20154';
	dummyWeapon1H := '6B95F';
	dummyWeapon2H := '6B95D';

	AddMessage('Patching ' + IntToStr(MaxPatchRecordIndex + 1) + ' Records');
	AddMessage(' ');
	
	signatures.Add('MISC');
	signatures.Add('ALCH');
	signatures.Add('INGR');
	signatures.Add('BOOK');
	signatures.Add('WEAP');
	signatures.Add('ARMO');
	signatures.Add('AMMO');
	signatures.Add('SLGM');
	
	//--------------------------------
	//Blacklists LVLI EditorIDs
	//Example: blackListLVLI.Add('DLC1RV03HunterArmor');
	//--------------------------------

	lastPercent := 0;

	for i := 0 to MaxPatchRecordIndex do begin
		rec := GetPatchRecord(i);

		//--------------------------------
		//Current process message
		//--------------------------------
		currentFile := BaseName(GetFile(Master(rec)));
		if not (Signature(rec) = currentSignature) then begin
				currentSignature := Signature(rec);
				AddMessage('----------------------------------------------------------------');
				AddMessage('Now patching ' + currentSignature + ' in ' + currentFile);
				AddMessage('----------------------------------------------------------------');
		end;

		//--------------------------------
		//Percent done message
		//--------------------------------
		if ((i  * 100) div MaxPatchRecordIndex) > lastPercent then begin
			AddMessage(IntToStr((i  * 100) div MaxPatchRecordIndex) + '% patched!');
			lastPercent := lastPercent + 1;
		end;
		
		editorID := geev(rec, 'EDID');
		formID := HexFormID(rec);

		//--------------------------------
		//Process records
		//--------------------------------
		if currentSignature = 'REFR' then begin
			//Check for potential errors
			if not Assigned(ebip(rec, 'NAME')) then begin
				Remove(rec);
				Continue;
			end;

			//Assign utility variables
			rName := geev(rec, 'NAME');
			rSignature := getSignature(rName);
			rEditorID := getEditorID(rName);
			rFormID := getFormID(rName);

			//Remove references that are not being patched
			if rFormID = '000DB0C9' then begin
				Remove(rec);
				Continue;
			end;

			if not hasPovertySignature(rSignature) then begin
			Remove(rec);
				Continue;
			end;

			//Add 'p' + editorID if not assigned
			lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + rEditorID);
			if not Assigned(lvliRecord) then begin
				lvliRecord := AddLVLI(mxPatchFile, '', rEditorID, rSignature, rFormID);
			end;

			//Process the reference record
			if not Assigned(ebip(rec, 'XLIB')) then
				Add(rec, 'XLIB', true);
			seev(rec, 'XLIB', HexFormID(lvliRecord));

			//Check for keywords of the name record
			rItemRecord := RecordByHexFormID(rFormID);
			for j := 0 to ElementCount(ebip(rItemRecord, 'KWDA')) do begin
				if IsWinningOverride(rItemRecord) then begin
					itemKeywords.Add(geev(rItemRecord, 'KWDA\[' + IntToStr(j) + ']'));
				end
				else begin
					itemKeywords.Add(geev(WinningOverride(rItemRecord), 'KWDA\[' + IntToStr(j) + ']'));
				end;
			end;
			
			if rSignature = 'ALCH' then begin
				seev(rec, 'NAME', dummyFood);
			end
			else if rSignature = 'AMMO' then begin
				seev(rec, 'NAME', dummyArrow);
			end
			else if rSignature = 'BOOK' then begin
				seev(rec, 'NAME', dummyBook);
			end
			else if rSignature = 'INGR' then begin
				seev(rec, 'NAME', dummyIngredient);
			end
			else if rSignature = 'SLGM' then begin
				seev(rec, 'NAME', dummySoulGem);
			end
			else if rSignature = 'ARMO' then begin
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ClothingNecklace [KYWD:0010CD0A]')) then begin
				seev(rec, 'NAME', dummyAmulet);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ArmorBoots [KYWD:0006C0ED]')) then begin
				seev(rec, 'NAME', dummyBoots);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ClothingCirclet [KYWD:0010CD08]')) then begin
				seev(rec, 'NAME', dummyCirclet);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ArmorCuirass [KYWD:0006C0EC]')) then begin
				seev(rec, 'NAME', dummyCuirass);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ArmorGauntlets [KYWD:0006C0EF]')) then begin
				seev(rec, 'NAME', dummyGauntlets);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ArmorHelmet [KYWD:0006C0EE]')) then begin
				seev(rec, 'NAME', dummyHelmet);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ClothingRing [KYWD:0010CD09]')) then begin
				seev(rec, 'NAME', dummyRing);
			end
			else if (rSignature = 'ARMO') and (IsInTStringList(itemKeywords, 'ArmorShield [KYWD:000965B2]')) then begin
				seev(rec, 'NAME', dummyShield);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeBattleaxe [KYWD:0006D932]')) then begin
				seev(rec, 'NAME', dummyBattleaxe);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeBow [KYWD:0001E715]')) then begin
				seev(rec, 'NAME', dummyBow);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeDagger [KYWD:0001E713]')) then begin
				seev(rec, 'NAME', dummyDagger);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeGreatsword [KYWD:0006D931]')) then begin
				seev(rec, 'NAME', dummyGreatSword);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeMace [KYWD:0001E714]')) then begin
				seev(rec, 'NAME', dummyMace);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'ArmorShield [KYWD:000965B2]')) then begin
				seev(rec, 'NAME', dummyStaff);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeWarAxe [KYWD:0001E712]')) then begin
				seev(rec, 'NAME', dummyWarAxe);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeWarhammer [KYWD:0006D930]')) then begin
				seev(rec, 'NAME', dummyWarhammer);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeSword [KYWD:0001E711]')) then begin
				seev(rec, 'NAME', dummyWeapon1H);
			end
			else if (rSignature = 'WEAP') and (IsInTStringList(itemKeywords, 'WeapTypeGreatsword [KYWD:0006D931]')) then begin
				seev(rec, 'NAME', dummyWeapon2H);
			end
			else if rSignature = 'MISC' then begin
				seev(rec, 'NAME', dummyClutter);
				if rEditorID = 'Gold001' then begin
					seev(rec, 'NAME', dummySeptim);
					Continue;
				end;
				for j := 0 to ReferencedByCount(rItemRecord) do begin
					if getSignature(geev(ReferencedByIndex(rItemRecord, j), 'Record Header\FormID')) = 'COBJ' then begin
						seev(rec, 'NAME', dummyResource);
						Continue;
					end;
				end;
			end;

			if not (Copy(getEditorID(geev(rec, 'NAME')), 0, 5) = 'Dummy') then begin
				failedFormIDs.Add(geev(rec, 'Record Header\FormID'));
				Remove(rec);
				Continue;
			end;
			itemKeywords.Clear;
		end
		else if currentSignature = 'CONT' then begin
			if Assigned(ebip(rec, 'Items')) then begin
				//Add Items to List and delete them
				for j := 0 to ElementCount(ebip(rec, 'Items')) - 1 do begin
					cItem := ebip(rec, 'Items\[0]');
					cItemsList.Add(geev(rec, 'Items\[0]\CNTO\Item'));
					cCountsList.Add(geev(rec, 'Items\[0]\CNTO\Count'));
					Remove(cItem);
				end;
				//Create new items and their Leveled List
				for j := 0 to cItemsList.Count - 1 do begin
					cNewItem := cItemsList[j];
					if ContainsText(cNewItem, 'Error: Could not be resolved') then begin
						errorFormIDs.Add(cNewItem + ' in ' + editorID);
						Continue;
					end;
					cEditorID := getEditorID(cNewItem);
					lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + cEditorID);
					if not Assigned(lvliRecord) then begin
						lvliRecord := AddLVLI(mxPatchFile, '', cEditorID, getSignature(cNewItem), getFormID(cNewItem));
					end;
					cItem := ElementAssign(ebip(rec, 'Items'), HighInteger, nil, false);
					seev(cItem, 'CNTO\Item', geev(lvliRecord, 'Record Header\FormID'));
					seev(cItem, 'CNTO\Count', cCountsList[j]);
				end;
			end
			else begin
				Remove(rec);
				Continue;
			end;
			cItemsList.Clear;
			cCountsList.Clear;
		end
		else if currentSignature = 'FLOR' then begin
			if Assigned(ebip(rec, 'PFIG')) then begin
				fIngredient := geev(rec, 'PFIG');
				fSignature := getSignature(fIngredient);
				fEditor := getEditorID(fIngredient);
				fFormID := getFormID(fIngredient);
				if not (fSignature = 'ALCH') then begin
					if not (fSignature = 'INGR') then begin
						Remove(rec);
						Continue;
					end;
				end;
				lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + fEditor);
				if not Assigned(lvliRecord) then begin
					lvliRecord := AddLVLI(mxPatchFile, 'FLOR', fEditor, fSignature, fFormID);
				end;
				seev(rec, 'PFIG', geev(lvliRecord, 'Record Header\FormID'));
			end
			else begin
				Remove(rec);
				Continue;
			end;
		end
		else if currentSignature = 'LVLI' then begin
			lEntries := ebip(rec, 'Leveled List Entries');
			if Assigned(lEntries) and (not (IsInTStringList(blackListLVLI, editorID))) then begin
				//Add Items to List and delete them
				k := 0;
				for j := 0 to ElementCount(lEntries) - 1 do begin
					if not (getSignature(geev(rec, 'Leveled List Entries\[0]\LVLO\Reference')) = 'LVLI') then begin
						lEntry := ebip(rec, 'Leveled List Entries\[' + IntToStr(k) + ']');
						lLevelList.Add(geev(rec, 'Leveled List Entries\[' + IntToStr(k) + ']\LVLO\Level'));
						lReferenceList.Add(geev(rec, 'Leveled List Entries\[' + IntToStr(k) + ']\LVLO\Reference'));
						lCountList.Add(geev(rec, 'Leveled List Entries\[' + IntToStr(k) + ']\LVLO\Count'));
						Remove(lEntry);
					end
					else begin
						k := k + 1;
					end;
				end;
				//Create new items and their Leveled List
				for j := 0 to lReferenceList.Count - 1 do begin
					lNewItem := lReferenceList[j];
					if ContainsText(lNewItem, 'Error: Could not be resolved') then begin
						errorFormIDs.Add(lNewItem + ' in ' + editorID);
						Continue;
					end;
					lEditorID := getEditorID(lNewItem);
					lSignature := getSignature(lNewItem);
					if not (lSignature = 'LVLI') then begin
						lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + lEditorID);
						if not Assigned(lvliRecord) then begin
							lvliRecord := AddLVLI(mxPatchFile, '', lEditorID, lSignature, getFormID(lNewItem));
						end;
						lEntry := ElementAssign(lEntries, HighInteger, nil, false);
						seev(lEntry, 'LVLO\Level', lLevelList[j]);
						seev(lEntry, 'LVLO\Reference', geev(lvliRecord, 'Record Header\FormID'));
						seev(lEntry, 'LVLO\Count', lCountList[j]);
					end;
				end;
			end
			else begin
				Remove(rec);
				Continue;
			end;
			lLevelList.Clear;
			lReferenceList.Clear;
			lCountList.Clear;
		end
		else if currentSignature = 'NPC_' then begin
			nItems := ebip(rec, 'Items');
			if Assigned(nItems) then begin
				k := 0;
				for j := 0 to ElementCount(nItems) - 1 do begin
					nItem := geev(rec, 'Items\[' + IntToStr(j) + ']\CNTO\Item');
					nEditorID := getEditorID(nItem);
					nSignature := getSignature(nItem);
					if not ((nSignature = 'KEYM') or (nSignature = 'LVLI') or (nSignature = 'WEAP')) then begin
						lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + nEditorID);
						if not Assigned(lvliRecord) then begin
							lvliRecord := AddLVLI(mxPatchFile, '', nEditorID, nSignature, getFormID(nItem));
						end
						seev(rec, 'Items\[' + IntToStr(j) + ']\CNTO\Item', geev(lvliRecord, 'Record Header\FormID'));
					end
					else begin
						k := k + 1;
					end;
				end;
				if j + 1 = k then begin
					Remove(rec);
					Continue;
				end;
			end
			else begin
				Remove(rec);
				Continue;
			end;
		end
		else if currentSignature = 'TREE' then begin
			if Assigned(ebip(rec, 'PFIG')) then begin
				tIngredient := geev(rec, 'PFIG');
				tEditorID := getEditorID(tIngredient);
				tSignature := getSignature(tIngredient);
				tFormID := getFormID(tIngredient);
				if not (tSignature = 'ALCH') then begin
					if not (tSignature = 'INGR') then begin
						Remove(rec);
						Continue;
					end;
				end;
				lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + tEditorID);
				if not Assigned(lvliRecord) then begin
					lvliRecord := AddLVLI(mxPatchFile, 'FLOR', tEditorID, tSignature, tFormID);
				end;
				seev(rec, 'PFIG', geev(lvliRecord, 'Record Header\FormID'));
			end
			else begin
				Remove(rec);
				Continue;
			end;
		end;
	end;

	//--------------------------------
	//Final warnings
	//--------------------------------
	if failedFormIDs.Count > 0 then begin
		AddMessage(' ');
		AddMessage('WARNING: Those References were not patched due to a lack of keywords in their base record');
		AddMessage(' ');
		AddMessageTStringList(failedFormIDs);
    end;
	if errorFormIDs.Count > 0 then begin
		AddMessage(' ');
		AddMessage('WARNING: Those records could not be used as they contain an error | Please contact the mod author politely');
		AddMessage(' ');
		AddMessageTStringList(errorFormIDs);
    end;

	//--------------------------------
	//MXPF Finalization
	//--------------------------------
	FinalizeMXPF;
end;

//--------------------------------
//Utility functions
//--------------------------------

function getFormID(s: string): string;
begin
  Result := Copy(s, Pos('[', s) + 6, 8);
end;

function getEditorID(s: string): string;
begin
  Result := Copy(s, 0, Pos(' ', s) - 1);
end;

function getSignature(s: string): string;
begin
  Result := Copy(s, Pos('[', s) + 1, 4);
end;

function RecordByEditorIDAllFiles(group, eid: string): IInterface;
var
    i: integer;
begin
    Result := nil;
    for i := 0 to FileCount - 1 do begin
				if HasGroup(FileByIndex(i), group) then begin
          if Assigned(MainRecordByEditorID(GroupBySignature(FileByIndex(i), group), eid)) then begin
						Result := MainRecordByEditorID(GroupBySignature(FileByIndex(i), group), eid);
            Exit;
          end
				end
    end
end;

function IsInTStringList(sl: TStringList; s: string): boolean;
var
	i: integer;
begin
	Result := false;
	for i := 0 to sl.Count - 1 do begin
		if sl.IndexOf(s) > -1  then begin
			Result := true;
			Exit;
		end;
	end;
end;

procedure AddMessageTStringList(sl: TStringList);
var
	i: integer;
begin
	for i := 0 to sl.Count - 1 do begin
		AddMessage(sl[i]);
	end;
end;

procedure AddMessageCurrentItemsStructure(rec: IInterface);
var
	i: integer;
begin
	for i := 0 to ElementCount(ebip(rec, 'Items')) - 1 do begin
		AddMessage(IntToStr(i) + ': ' + geev(rec, 'Items\[' + IntToStr(i) + ']\CNTO\Item'));
	end;
end;

function hasPovertySignature(s: string): bool;
var
	i: integer;
begin
	Result := false;
	if (s = 'ALCH') then begin
		Result := true;
	end
	else if (s = 'AMMO') then begin
		Result := true;
	end
	else if (s = 'ARMO') then begin
		Result := true;
	end
	else if (s = 'BOOK') then begin
		Result := true;
	end
	else if (s = 'INGR') then begin
		Result := true;
	end
	else if (s = 'MISC') then begin
		Result := true;
	end
	else if (s = 'SLGM') then begin
		Result := true;
	end
	else if (s = 'WEAP') then begin
		Result := true;
	end
end;

function AddLVLI(f: IInterface; variant, eid, sig, form: string): IInterface;
var
  povertyFileLoadOrder: string;
  lvli, pAmmo, pArmor, pBook, pIngredient, pClutter, pSoulGem, pWeapon, pFood, pHarvestFoodFlora, pPotion, pResource, pGold, pDrink, pHarvestIngredientsFlora, pHarvestFoodNPC, pHarvestResourceNPC, pAmmoNPC, pMerchantGold, pBookSpell, pHarvestFoodFloraHanging, pHarvestIngredientsNPC, pMineNotInUse, pBugFishNotInUse: IInterface;
begin
  //Get global value from Poverty
  povertyFileLoadOrder := IntToStr(GetLoadOrder(FileByName('Poverty.esp')));
  pAmmo := povertyFileLoadOrder + '000802';
  pArmor := povertyFileLoadOrder + '005911';
  pBook := povertyFileLoadOrder + '005912';
  pIngredient := povertyFileLoadOrder + '005913';
  pClutter := povertyFileLoadOrder + '005914';
  pSoulGem := povertyFileLoadOrder + '005915';
  pWeapon := povertyFileLoadOrder + '005916';
  pFood := povertyFileLoadOrder + '00AA18';
  pHarvestFoodFlora := povertyFileLoadOrder + '00AA19';
  pPotion := povertyFileLoadOrder + '00AA1A';
  pResource := povertyFileLoadOrder + '00AA1B';
  pGold := povertyFileLoadOrder + '00FB1E';
  pDrink := povertyFileLoadOrder + '014C21';


  if not Assigned(GroupBySignature(f, 'LVLI')) then
    Add(f, 'LVLI', true);
  lvli := Add(GroupBySignature(f, 'LVLI'), 'LVLI', true);

  //Add EditorID
  Add(lvli, 'EDID', true);
  seev(lvli, 'EDID', 'p' + eid);
  //Add Flag
  SetNativeValue(ebip(lvli, 'LVLF'), GetNativeValue(ebip(lvli, 'LVLF')) or 1 shl 1);

  //Add Global
  Add(lvli, 'LVLG', true);
  ProcessLVLG(variant, sig, lvli);

  //Add Count
  Add(lvli, 'LLCT', true);
  seev(lvli, 'LLCT', '1');

  //Add Leveled List Entry
  Add(lvli, 'Leveled List Entries', true);
  seev(lvli, 'Leveled List Entries\[0]\LVLO\Level', '1');
  seev(lvli, 'Leveled List Entries\[0]\LVLO\Reference', form);
  seev(lvli, 'Leveled List Entries\[0]\LVLO\Count', '1');
  Result := lvli;
end;

procedure ProcessLVLG(variant, sig: string; lvli: IInterface);
var
	povertyFileLoadOrder: string;
	pAmmo, pArmor, pBook, pIngredient, pClutter, pSoulGem, pWeapon, pFood, pHarvestFoodFlora, pPotion, pResource, pGold, pDrink, pHarvestIngredientsFlora, pHarvestFoodNPC, pHarvestResourceNPC, pAmmoNPC, pMerchantGold, pBookSpell, pHarvestFoodFloraHanging, pHarvestIngredientsNPC, pMineNotInUse, pBugFishNotInUse: IInterface;
begin
	povertyFileLoadOrder := IntToStr(GetLoadOrder(FileByName('Poverty.esp')));
	pAmmo := povertyFileLoadOrder + '000802';
	pArmor := povertyFileLoadOrder + '005911';
	pBook := povertyFileLoadOrder + '005912';
	pIngredient := povertyFileLoadOrder + '005913';
	pClutter := povertyFileLoadOrder + '005914';
	pSoulGem := povertyFileLoadOrder + '005915';
	pWeapon := povertyFileLoadOrder + '005916';
	pFood := povertyFileLoadOrder + '00AA18';
	pPotion := povertyFileLoadOrder + '00AA1A';
	pResource := povertyFileLoadOrder + '00AA1B';
	pGold := povertyFileLoadOrder + '00FB1E';
	pDrink := povertyFileLoadOrder + '014C21';
	povertyFileLoadOrder := IntToStr(GetLoadOrder(FileByName('Poverty.esp')));
	pHarvestFoodFlora := povertyFileLoadOrder + '00AA19';
	pHarvestFoodFloraHanging := povertyFileLoadOrder + '01A3D7';
	pHarvestIngredientsFlora := povertyFileLoadOrder + '014CA1';
	pHarvestFoodNPC := povertyFileLoadOrder + '01A023';
	pHarvestIngredientsNPC := povertyFileLoadOrder + '01A3DA';
	pHarvestResourceNPC := povertyFileLoadOrder + '01A162';

	if variant = 'FLOR' then begin
		if sig = 'ALCH' then begin
			seev(lvli, 'LVLG', pHarvestFoodFlora);
		end
		else if sig = 'ALCH' then begin
			seev(lvli, 'LVLG', pHarvestFoodFloraHanging);
		end
		else if sig = 'ALCH' then begin
			seev(lvli, 'LVLG', pHarvestFoodNPC);
		end
		else if sig = 'INGR' then begin
			seev(lvli, 'LVLG', pHarvestIngredientsFlora);
		end
		else if sig = 'INGR' then begin
			seev(lvli, 'LVLG', pHarvestIngredientsNPC);
		end
		else if sig = 'TREE' then begin
			seev(lvli, 'LVLG', pHarvestResourceNPC);
		end;
	end
	else begin
		if sig = 'ALCH' then begin
			seev(lvli, 'LVLG', pFood);
		end
		else if sig = 'AMMO' then begin
			seev(lvli, 'LVLG', pAmmo);
		end
		else if sig = 'ARMO' then begin
			seev(lvli, 'LVLG', pArmor);
		end
		else if sig = 'BOOK' then begin
			seev(lvli, 'LVLG', pBook);
		end
		else if sig = 'INGR' then begin
			seev(lvli, 'LVLG', pIngredient);
		end
		else if sig = 'MISC' then begin
			seev(lvli, 'LVLG', pClutter);
		end
		else if sig = 'SLGM' then begin
			seev(lvli, 'LVLG', pSoulGem);
		end
		else if sig = 'WEAP' then begin
			seev(lvli, 'LVLG', pWeapon);
		end;
	end;
end;

function StrIndex(s: string; sl: TStringList): integer;
var
	i: integer;
begin
	for i := 0 to Length(sl) - 1 do begin
		if sl[0] = string then begin
			Result := i;
			Exit;
		end;
		sl.Delete(0);
	end;
	Result := -1;
end;

end.

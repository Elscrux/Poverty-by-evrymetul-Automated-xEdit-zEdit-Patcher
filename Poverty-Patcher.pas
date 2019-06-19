unit UserScript;

uses 'lib\mxpf';

function Initialize: integer;

var
  changed: boolean;
  i, j, k, lastPercent: integer;
  currentFile, currentSignature, editorID, formID, rName, rFormID, rEditorID, rSignature, fIngredient, fEditor, lNewItem, fSignature, fFormID, lEditorID, lSignature, lFormID, cNewItem, cEditorID, cSignature, nItem, nEditorID, nSignature, tIngredient, tEditorID, tSignature, tFormID, povertyFileLoadOrder, dummyDrink, dummyFood, dummyPotion, dummyArrow, dummyAmulet, dummyBoots, dummyCirclet, dummyCuirass, dummyGauntlets, dummyHelmet, dummyRing, dummyShield, dummyBook, dummyIngredient, dummyClutter, dummyResource, dummySeptim, dummySoulGem, dummyBattleaxe, dummyBow, dummyDagger, dummyGreatSword, dummyMace, dummyStaff, dummySword, dummyWarAxe, dummyWarhammer, dummyWeapon1H, dummyWeapon2H: string;
  rec, lvliRecord, rItemRecord, ItemsListubRecord, cItem, lEntries, lEntry, nItems: IInterface;
  referenceKeywords, failedFormIDs, errorFormIDs, cItemsList, cCountsList, lLevelList, lReferenceList, lCountList, blackListLVLI, blackListREFR: TStringList;

begin
	//--------------------------------
	//MXPF Initialization
	//--------------------------------
	InitializeMXPF;
	DefaultOptionsMXPF;

	//Name this whatever you like
	PatchFileByName('Poverty All-in-One Patch.esp');
	
	//Add Poverty as master
	AddMasterIfMissing(mxPatchFile, 'Poverty.esp');
	
	//Set File Header variables
	seev(mxPatchFile, 'CNAM', 'Evrymetul and Elscrux');
	seev(mxPatchFile, 'SNAM', 'Patch for Poverty');
	
	SetExclusions('Poverty.esp');
	SetInclusions('HearthFires.esm');
	//SetInclusions('Dawnguard.esm');

	//--------------------------------
	//Loading records
	//--------------------------------
	LoadChildRecords('CELL', 'REFR');
	LoadChildRecords('WRLD', 'REFR');
	LoadRecords('CONT');
	LoadRecords('FLOR');
	LoadRecords('LVLI');
	LoadRecords('NPC_');
	LoadRecords('TREE');
	
	//--------------------------------
	//MESSAGE: Records loaded
	//--------------------------------
	AddMessage('Records loaded');
	
	//MXPF: Copy to patch
	CopyRecordsToPatch;

	//--------------------------------
	//MESSAGE: Records copied
	//--------------------------------
	AddMessage('Records copied to patch');
	
	//--------------------------------
	//Creating TStringLists
	//--------------------------------
	referenceKeywords := TStringList.Create;
	failedFormIDs := TStringList.Create;
	errorFormIDs := TStringList.Create;
	cItemsList := TStringList.Create;
	cCountsList := TStringList.Create;
	lLevelList := TStringList.Create;
	lReferenceList := TStringList.Create;
	lCountList := TStringList.Create;
	blackListLVLI := TStringList.Create;
	blackListREFR := TStringList.Create;

	//--------------------------------
	//Get dummys from Skyrim & Poverty
	//--------------------------------
	povertyFileLoadOrder := IntToStr(GetLoadOrder(FileByName('Poverty.esp')));
	
	//ALCH
	dummyDrink := povertyFileLoadOrder + '01A21D';
	dummyFood := povertyFileLoadOrder + '01A21E';
	dummyPotion := '6A07E';
	//AMMO
	dummyArrow := '6A0BF';
	//ARMO
	dummyAmulet := povertyFileLoadOrder + '014C9A';
	dummyBoots := '6A0A9';
	dummyCirclet := povertyFileLoadOrder + '019DD5';
	dummyCuirass := '6A0AB';
	dummyGauntlets := '6A0AD';
	dummyHelmet := '6A0AF';
	dummyRing := povertyFileLoadOrder + '014C99';
	dummyShield := '6A0B1';
	//BOOK
	dummyBook := 'D7866';
	//INGR
	dummyIngredient := povertyFileLoadOrder + '01A017';
	//MISC
	dummyClutter := povertyFileLoadOrder + '01A163';
	dummyResource := povertyFileLoadOrder + '01A153';
	dummySeptim := povertyFileLoadOrder + '01A119';
	//SLGM
	dummySoulGem := '6A0C2';
	//WEAP
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
	
	//--------------------------------
	//MESSAGE: Number of Records
	//--------------------------------
	AddMessage('Patching ' + IntToStr(MaxPatchRecordIndex + 1) + ' Records');
	AddMessage(' ');
	
	//--------------------------------
	//Blacklists LVLI EditorIDs
	//-------------------------------- 
	
	
	//--------------------------------
	//Blacklists REFR EditorIDs
	//--------------------------------
	blackListREFR.Add('DefaultBookShelfBookMarker');
	
	
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
			
			//Assign utility variables
			rName := geev(rec, 'NAME');
			rSignature := getSignature(rName);
			rEditorID := getEditorID(rName);
			rFormID := getFormID(rName);
			
			//Check for potential errors and sort out records that shall not be processed
			if Assigned(ebip(rec, 'NAME')) and hasPovertySignature(rSignature) and (not IsInTStringList(blackListREFR, rEditorID)) then begin
				
				//Add poverty LVLI record
				lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + rEditorID);
				if not Assigned(lvliRecord) then
					lvliRecord := AddLVLI(mxPatchFile, '', rEditorID, rFormID);
				
				//Add XLIB to reference
				if not Assigned(ebip(rec, 'XLIB')) then
					Add(rec, 'XLIB', true);
				seev(rec, 'XLIB', HexFormID(lvliRecord));

				//Check for keywords of the placed base record
				rItemRecord := RecordByHexFormID(rFormID);
				for j := 0 to ElementCount(ebip(rItemRecord, 'KWDA')) do begin
					if IsWinningOverride(rItemRecord) then begin
						referenceKeywords.Add(geev(rItemRecord, 'KWDA\[' + IntToStr(j) + ']'));
					end
					else begin
						referenceKeywords.Add(geev(WinningOverride(rItemRecord), 'KWDA\[' + IntToStr(j) + ']'));
					end;
				end;
				
				//Change the name
				Case Pos(rSignature, 'ALCH|AMMO|ARMO|BOOK|INGR|MISC|SLGM|WEAP') of
					1: seev(rec, 'NAME', dummyFood);
						6: seev(rec, 'NAME', dummyArrow);
						11: begin
								for j := 0 to referenceKeywords.Count - 1 do begin
									Case Pos(referenceKeywords[j], 'ArmorBoots|ArmorCuirass|ArmorGauntlets|ArmorHelmet|ArmorShield|ClothingCirclet|ClothingRing') of
										1: seev(rec, 'NAME', dummyBoots);
										12: seev(rec, 'NAME', dummyCuirass);
										25: seev(rec, 'NAME', dummyGauntlets);
										40: seev(rec, 'NAME', dummyHelmet);
										52: seev(rec, 'NAME', dummyShield);
										64: seev(rec, 'NAME', dummyCirclet);
										80: seev(rec, 'NAME', dummyRing);
									end;
								end;
							end;
						16: seev(rec, 'NAME', dummyBook);
						21: seev(rec, 'NAME', dummyIngredient);
						26: begin
								seev(rec, 'NAME', dummyClutter);
								if rEditorID = 'Gold001' then begin
									seev(rec, 'NAME', dummySeptim);
									Continue;
								end;
								for j := 0 to ReferencedByCount(rItemRecord) - 1 do begin
									if getSignature(geev(ReferencedByIndex(rItemRecord, j), 'Record Header\FormID')) = 'COBJ' then begin
										seev(rec, 'NAME', dummyResource);
										Continue;
									end;
								end;
							end;
						31: seev(rec, 'NAME', dummySoulGem);
						36: begin
								for j := 0 to referenceKeywords.Count - 1 do begin
									Case Pos(referenceKeywords[j], 'WeapTypeBattleaxe|WeapTypeBow|WeapTypeDagger|WeapTypeGreatsword|WeapTypeMace|WeapTypeSword|WeapTypeGreatsword|WeapTypeWarAxe|WeapTypeWarhammer|WeapTypeStaff') of
										1: seev(rec, 'NAME', dummyBattleaxe);
										19: seev(rec, 'NAME', dummyBow);
										31: seev(rec, 'NAME', dummyDagger);
										46: seev(rec, 'NAME', dummyGreatSword);
										65: seev(rec, 'NAME', dummyMace);
										78: seev(rec, 'NAME', dummySword);
										92: seev(rec, 'NAME', dummyGreatSword);
										111: seev(rec, 'NAME', dummyWarAxe);
										126: seev(rec, 'NAME', dummyWarhammer);
										144: seev(rec, 'NAME', dummyStaff);
									end;
								end;
							end;
						else begin
							failedFormIDs.Add(geev(rec, 'Record Header\FormID'));
							Remove(rec);
							Continue;
						end;
				end;
				
				//Remove record if it was not successfully processed
				if not (Copy(getEditorID(geev(rec, 'NAME')), 0, 5) = 'Dummy') then begin
					failedFormIDs.Add(geev(rec, 'Record Header\FormID'));
					Remove(rec);
					Continue;
				end;
				referenceKeywords.Clear;
			end
			else begin
				Remove(rec);
				Continue;
			end;
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
						lvliRecord := AddLVLI(mxPatchFile, '', cEditorID, getFormID(cNewItem));
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
					lvliRecord := AddLVLI(mxPatchFile, 'FLOR', fEditor, fFormID);
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
					if (not (getSignature(geev(rec, 'Leveled List Entries\[0]\LVLO\Reference')) = 'LVLI')) and (not (Copy(getEditorID(geev(rec, 'Leveled List Entries\[0]\LVLO\Reference')), 0, 5) = 'Dummy')) then begin
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
						if ContainsText(geev(rec, 'EDID'), 'Vendor') and (lEditorID = 'Gold001') then begin
							lEditorID := lEditorID + 'M';
						end;
						lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + lEditorID);
						if not Assigned(lvliRecord) then begin
							lvliRecord := AddLVLI(mxPatchFile, '', lEditorID, getFormID(lNewItem));
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
					nSignature := getSignature(cNewItem);
					if not ((nSignature = 'KEYM') or (nSignature = 'LVLI') or (nSignature = 'WEAP')) then begin
						lvliRecord := RecordByEditorIDAllFiles('LVLI', 'p' + cEditorID);
						if not Assigned(lvliRecord) then begin
							lvliRecord := AddLVLI(mxPatchFile, '', cEditorID, getFormID(cNewItem));
						end;
						cItem := ElementAssign(ebip(rec, 'Items'), HighInteger, nil, false);
						seev(cItem, 'CNTO\Item', geev(lvliRecord, 'Record Header\FormID'));
						seev(cItem, 'CNTO\Count', cCountsList[j]);
					end
					else begin
						cItem := ElementAssign(ebip(rec, 'Items'), HighInteger, nil, false);
						seev(cItem, 'CNTO\Item', cItemsList[j]);
						seev(cItem, 'CNTO\Count', cCountsList[j]);
					end;
				end;
			end
			else begin
				Remove(rec);
				Continue;
			end;
			cItemsList.Clear;
			cCountsList.Clear;
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
					lvliRecord := AddLVLI(mxPatchFile, 'FLOR', tEditorID, tFormID);
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

function AddLVLI(f: IInterface; variant, eid, fid: string): IInterface;
var
	signature, reference, povertyFileLoadOrder, pAmmo, pArmor, pBook, pIngredient, pClutter, pSoulGem, pWeapon, pFood, pHarvestFoodFlora, pPotion, pResource, pGold, pDrink, pHarvestIngredientsFlora, pHarvestFoodNPC, pHarvestResourceNPC, pAmmoNPC, pMerchantGold, pBookSpell, pHarvestFoodFloraHanging, pHarvestIngredientsNPC, pMineNotInUse, pBugFishNotInUse: string;
	innerlvli, lvli, itemRecord: IInterface;
begin
  //Get global value from Poverty
	povertyFileLoadOrder := IntToStr(GetLoadOrder(FileByName('Poverty.esp')));
	//ALCH
	pHarvestFoodFlora := povertyFileLoadOrder + '00AA19';
	pFood := povertyFileLoadOrder + '00AA18';
	//AMMO
	pAmmo := povertyFileLoadOrder + '000802';
	//ARMO
	pArmor := povertyFileLoadOrder + '005911';
	//BOOK
	pBook := povertyFileLoadOrder + '005912';
	//INGR
	pIngredient := povertyFileLoadOrder + '005913';
	
	pHarvestIngredientsFlora := povertyFileLoadOrder + '014CA1';
	//MISC
	pClutter := povertyFileLoadOrder + '005914';
	pResource := povertyFileLoadOrder + '00AA1B';
	pGold := povertyFileLoadOrder + '00FB1E';
	pMerchantGold := povertyFileLoadOrder + '01A17F';
	//SLGM
	pSoulGem := povertyFileLoadOrder + '005915';
	//WEAP
	pWeapon := povertyFileLoadOrder + '005916';
	
	//Not used right now
	pPotion := povertyFileLoadOrder + '00AA1A';
	pDrink := povertyFileLoadOrder + '014C21';
	pHarvestFoodFloraHanging := povertyFileLoadOrder + '01A3D7';
	pHarvestFoodNPC := povertyFileLoadOrder + '01A023';
	pHarvestIngredientsNPC := povertyFileLoadOrder + '01A3DA';
	pHarvestResourceNPC := povertyFileLoadOrder + '01A162';
	pAmmoNPC := povertyFileLoadOrder + '01A17E';
	pBookSpell := povertyFileLoadOrder + '01A21F';
	pMineNotInUse := povertyFileLoadOrder + '01A44E';
	pBugFishNotInUse := povertyFileLoadOrder + '01A44F';
	
	//Add group record and lvliRecord
	if not Assigned(GroupBySignature(f, 'LVLI')) then
		Add(f, 'LVLI', true);
	lvli := Add(GroupBySignature(f, 'LVLI'), 'LVLI', true);

	//Add EditorID
	Add(lvli, 'EDID', true);
	seev(lvli, 'EDID', 'p' + eid);
	
	//Add Flag
	SetNativeValue(ebip(lvli, 'LVLF'), GetNativeValue(ebip(lvli, 'LVLF')) or 1 shl 1);
	
	//Add Count
	Add(lvli, 'LLCT', true);
	seev(lvli, 'LLCT', '1');
	
	//Add Leveled List Entry
	Add(lvli, 'Leveled List Entries', true);
	seev(lvli, 'Leveled List Entries\[0]\LVLO\Level', '1');
	seev(lvli, 'Leveled List Entries\[0]\LVLO\Reference', fid);
	seev(lvli, 'Leveled List Entries\[0]\LVLO\Count', '1');
	Result := lvli;
	
	//Add Global
	Add(lvli, 'LVLG', true);
	reference := geev(lvli, 'Leveled List Entries\[0]\LVLO\Reference');
	while getSignature(reference) = 'LVLI' do begin
		innerlvli := RecordByHexFormID(getFormID(reference));
		reference := geev(innerlvli, 'Leveled List Entries\[0]\LVLO\Reference');
	end;
	signature := getSignature(reference);
	Case Pos(signature, 'ALCH|AMMO|ARMO|BOOK|INGR|MISC|SLGM|WEAP') of
		1: 	begin
				if variant = 'FLOR' then begin
					seev(lvli, 'LVLG', pHarvestFoodFlora);
				end
				else begin
					seev(lvli, 'LVLG', pFood);
				end;
			end;	
		6: seev(lvli, 'LVLG', pAmmo);
		11: seev(lvli, 'LVLG', pArmor);
		16: seev(lvli, 'LVLG', pBook);
		21: begin
				if variant = 'FLOR' then begin
					seev(lvli, 'LVLG', pHarvestIngredientsFlora);
				end
				else begin
					seev(lvli, 'LVLG', pIngredient);
				end;
			end;
		26: begin
				seev(lvli, 'LVLG', pClutter);
				if eid = 'Gold001' then begin
					seev(lvli, 'LVLG', pGold);
					Continue;
				end;
				if eid = 'Gold001M' then begin
					seev(lvli, 'LVLG', pMerchantGold);
					Continue;
				end;
				itemRecord := RecordByHexFormID(fid);
				//Access violation FIX THAT
				for j := 0 to ReferencedByCount(itemRecord) - 1 do begin
					if getSignature(geev(ReferencedByIndex(itemRecord, j), 'Record Header\FormID')) = 'COBJ' then begin
						seev(lvli, 'LVLG', pResource);
						Continue;
					end;
				end;
			end;
		31: seev(lvli, 'LVLG', pSoulGem);
		36: seev(lvli, 'LVLG', pWeapon);
	end;
end;

end.

SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "roughborough" (gid serial,
"id" int4);
ALTER TABLE "roughborough" ADD PRIMARY KEY (gid);
SELECT AddGeometryColumn('','roughborough','geom','2263','MULTIPOLYGON',2);
INSERT INTO "roughborough" ("id",geom) VALUES ('5','0106000020D7080000010000000103000000010000002F00000080CB50356BF52B4100F8EB5776FAFC4000B8500CD8DC2B4100B40D037D62FD4080B7504CB0D32B4100E89BE665FAFD4000B8508C27EF2B4100242ACAA792FF40007FC20834E82B4100666ABA80BF0041007FC2283F082C4100686A3A175801410063FB56E3372C4100DA8601266F0141807FC26855482C410084312CB4B602418062FB36E1542C410030DC561E0A0341004634E5CB592C41001215658B4A0341004634851D4F2C41004AA3C8E6860341009C895A26512C4100D8860154020441002A6DF3FA502C4100D88601C7570441807FC2688A542C41009EF89DE7AD044100F1DE8FDD5D2C4100BCBF0F72E10441809B89FA4B772C41008431ACFC4F0541009C897AD0952C410082312C1756054100B8508C77B22C41002EDC560E54054180F0DE6FE4B72C41002EDC563A230541800DA6C16C082D4100101565083F0541000DA641BC1A2D41004AA3C8F9620541000DA68133362D41002EDCD6285A0541000DA6A1094A2D41004CA3487E81054180B7504C505A2D41004AA3C8CD93054180D417BE70752D4100F64DF38F85054100B850AC687D2D410084312C928604418062FB7650952D4100F44D730A05044100B850CC739D2D4100666ABAE35E0341800DA681DB972D41002EDCD6FAC6024180B7504C59972D41004AA348610602418062FBB692A42D4100101565EBC3014100F1DECF4C9E2D4100BCBF8FADB501418062FB56E4992D410030DCD66CBA014180B7502C83832D4100DA8681038E02410063FB767C642D4100DA86815B2C0241807E7D9A0E442D41009EA551C591014100DBDB015B432D4100B0229FA5590141800182F668012D4100CC8CC2A9AB0041008C243BC8F42C41008E1A85D543004100E6ACF5EDDC2C4100B0E006BFF5FF400059340468D22C41004AF335FF3200418066E9156A7B2C410080936330F9FE40804DEAC1156E2C410094FD86344BFE40007858F2014B2C410050D6375E3AFE40807674D4923B2C410044B648E5BEFD4000E633A72E122C41006C405B628CFD4080CB50356BF52B4100F8EB5776FAFC40');
INSERT INTO "roughborough" ("id",geom) VALUES ('1','0106000020D7080000010000000103000000010000004A00000080F26E65D0A32D4100F025B4242C074100D6A75B7E9D2D4100EE25A4894F0741802BFDB024A52D4100447BF9F69E0741802BFDB053B22D4100EC25A47DCE074100D6A75BCABA2D41009AD04E6CC3074180D5A75B4DBA2D4100EE25A44584074180D5A75B76C82D410098D04E00580741002BFDB0BCDF2D410098D04E40770741002BFDB057DB2D41009AD04E28F8074100D6A75B57E22D41009AD04EA48A08410080520651EA2D410098D04E406B0941002BFDB0F7EA2D410098D04E60B90941008052060FF52D4100F025A44D470A41002BFDB01F0E2E4100447BF932000B4100805206E9242E41009AD04E08920B41002BFDB075532E41009AD04EA4EF0C41002CFDB0B5722E41009AD04ED4E10D41008152065C7A2E4100467BF9326B0E41808052066CA12E4100EE25A4F58A0F4100D5A75B1EA72E410098D04E0CA30F41008152060CB12E4100F025A4899C0F41802BFDB02FB22E410098D04E848F0F418081520659B92E4100447BF98A800F4180D5A75B05C02E4100F025A43D7F0F41008252067CC82E410098D04E38720F4180805206EDCA2E41009AD04E74680F4100D6A75BBDCB2E4100467BF96E5B0F41802BFDB099CA2E41009AD04E703F0F4180815206FFC72E41009AD04E00280F4100D6A75B6AC42E4100467BF94E0D0F4180815206ACC02E4100447BF9D2F70E410081520653BA2E4100447BF9B6D20E41802AFDB01DB52E4100EE25A4F9B90E41802BFDB0F4A62E4100F025A475520E41002CFDB095A12E4100447BF9CA280E4180805206789F2E41009AD04EC00E0E4100805206A8972E41009AD04E94C20D41002CFDB05A962E4100427BF9CAAB0D4100D5A75BFB972E41009AD04ED4640D4180D6A75B72992E4100EE25A4E91B0D41008052069C992E4100427BF9F2D40C41002CFDB04E982E4100427BF94E9C0C41802BFDB0C5992E4100447BF9D2860C41008152067E9E2E41009AD04EE0680C4180D5A75BA3A42E4100EE25A4603C0C41808052C689AA2E4100447BF98F420C4180D6A79B7AB02E41009AD04EE9410C41002CFD3064B22E4100F025A45A3D0C418081528634B32E4100447BF948390C4100D6A71BA1B42E4100EE25A4C02C0C41802BFD30CFB52E41009AD04E1A250C41808052C6B8B72E41009AD04EBB1F0C410081528687BA2E4100447BF98B190C4180815206B4BD2E4100EE25A4D9130C41002BFD3099BE2E410098D04E98100C4100D7A79B91C12E4100447BF98C040C41009E1990BFC62E4100F025B450DD0B418047C47A74B52E4100F025B4A87B0B410047C47AB0AB2E4100447B0969550B410048C43AC1A32E4100447B09C3460B418048C4FA60992E4100447B09F8520B4100F36EE5F78C2E41009AD05E0B340B41009D19D0C38C2E410098D05E27DC0A4180F26EE5C2802E4100EE25B40C9B0A4100F26EA5F1732E41009AD05E8D4E0A41809D19D0B3652E4100427B09F0060A41009D195064532E4100F025B4249D0941009E19D067482E41009AD05E7A7208418048C43AC63A2E4100F025B4F518084100F26EE5A91C2E4100447B09910D084100F26E25FAFF2D4100F025B482C30741009D199058F22D4100EE25B4B329074180F26EA540D52D410098D05EA5DF064180F26E65D0A32D4100F025B4242C0741');
INSERT INTO "roughborough" ("id",geom) VALUES ('3','0106000020D7080000010000000103000000010000005000000000A6BA8513C72E4100127B99C2F60B4100DF488968C42E41004A097DD2FE0B4180349EDEE6C12E41004A09FDA8070C4180DD48E918BE2E41004A09FD60130C4180DE486963BC2E4100F2B3A7F5160C4100DF4829B4BA2E4100F4B327221A0C4100DF48892DB92E4100F2B327101D0C4100349EDE8CB72E41009E5ED221210C4180349EFEE0B62E4100F4B3A7AD220C410089F333ECB52E41009E5E52C5250C4100DF4829D8B42E410048097D862C0C4100349E5E60B42E410048097D6E300C4100339EFE75B32E4100A05ED28B390C418089F3F3DEB22E41004A09FDE73B0C4180349E7E3DB22E410048097D973E0C410089F3D3A2AF2E4100A05ED243450C4100DF48E983A82E4100F4B32720440C4100DF4829B5A52E41004A097DEA450C418089F3D36DA32E4100F2B327E6550C4180DE48A9359B2E4100A05ED2428C0C4180DE4829FD992E41009E5ED2539E0C418089F353E29A2E410048097D07BA0C418089F313409B2E4100F4B32794E80C410089F353659A2E41009E5ED26D380D4180DD48A947982E4100A05ED2D19C0D418088F3D3AF982E4100F4B32777B90D4100DF48296E9C2E410048097D6FDD0D4180DD4829D3A02E410048097D4B150E4180DD48A972AE2E41004A097DBD7F0E4180DF4869FFBB2E410048097D67D00E4180349E7E74C62E4100A05ED2400E0F4180349E3E31CC2E41004A097D8F3E0F4100DE48A9B8CC2E41009E5ED2F8640F4100DF48290FC92E4100F2B327E6750F4180339EBE28C32E4100A05ED2D37F0F4180DD4869F3BD2E41004A097DD9850F4100DE48296FB92E41009E5ED2AF850F4100349E7E95B42E41004A097DE3940F4100349EFEE5B12E4100F4B32730A40F4100DE48296CAD2E4100A05ED2B2AA0F4180349E3EEAA92E4100BA2544B9A80F41806B2C2250C52E410088BD4C6B941041006D2C228CBB2E4100A484BEE5A01041006D2C228CBB2E4100C04B30CAC5104180DF48E9B1E32E41003368F7DFC61041005065B0C7E42E41003268F7CF9F1041806B2C22A51F2F41006CF6DA5AA01041806B2C22A51F2F4100FAD91335781041005065B058352F41003268F7BF78104180349E3E13352F41003268F7CF9F10410018D7CC6C592F41006CF6DA5AA010410018D7CC6C592F41003268F7BF78104100349E3E3A6D2F41003268F7BF78104100FC0F5BAF6C2F4100C04B309A5010410018D7CC7C802F410088BD4C0F5010410018D7CC7C802F410088BD4CFF281041005065B02EB92F4100FAD91333251041005065B02EB92F4100F4B32746FC0F41804F65B0D4C72F410064D0EE5BFD0F4180A6BA059EDE2F41009E5ED27CE50F4100DF48E999E12F410082976098C00F418088F3933AE32F4100F2B32762A40F418017D7CC24E22F4100D8ECB55D310F41001A4F9F840330410080976038D60E41408B6BE66103304100BA2544CD040E41806D2C220CF42F41000E7B994AFE0D4180FA0F5BF6F22F41002C420BC3B70D41004F65B0F9AC2F410048097D97B50D4100C181779EAB2F4100BC2544A98D0D41804F65B081C02F410082976048090D41806B2C2238C32F41002E420B23AE0C4180349E3E53D12F410066D0EE43960C4180A4BA054BD72F4100829760F8450C4180A5BA85F2872F4100D8ECB585660C4180A5BA859D2D2F410048097D13540C410089F31323212F4100D6ECB571990B418089F313D0192F410048097D3B7D0B418088F31348062F410048097D77730B4100A5BA859BDA2E4100D6ECB545CA0B4100A6BA8513C72E4100127B99C2F60B41');
INSERT INTO "roughborough" ("id",geom) VALUES ('2','0106000020D70800000100000001030000000100000062000000803F96F669F02D4100F6DA47DCCB01410046167FAEE32D4100F448DF1251024180552DE992032E4100B441C531AC02418029755FC0012E41006AE97061FC024100B662D73CE82D410096687F1947034100AFD67752BE2D410096687F194703418019E22EB5A82D4100385691D933044100C48C5970B02D4100561D03A403054180E0534B46CD2D410070E4740691054100A7C56743E02D41001C8F1FA9E505418035A9A0BCDC2D4100541D0376D506410035A9E01CE72D410070E47472F606410019E2EE44F42D4100AA7258EF220741005270D275032E410000C8AD06AA07410036A9E09D102E4100E4003CCAE6074180DF538B021C2E4100581D0368FB07410036A960E6382E4100AC72588B03084100FD1ABDBB422E4100E4003C3E27084100E153CB36572E4100E4003CE8DB084180A7C5E728572E4100C639CAB79309410052701212812E4100541D038A900A4100FD1ABD058A2E4100541D035EC10A41805270D20F912E4100385691DBDF0A418019E2EE138E2E41001C8F1F35040B4180A7C5276F8F2E410072E474E01F0B4180E1538B14962E4100E2003C423E0B4100E153CBBBA92E410090ABE6E23F0B4100E1534BB1CA2E41003A56911DCF0B41808AFEF5D9DF2E4100541D036AB90B4100A7C56753012F410090ABE6884E0B41808BFEF5B30F2F410090ABE6B6700B410036A9206F172F410090ABE610620B410036A920C21E2F4100AA7258D78B0B4100A7C5E748222F410038569167990B4180DF534B5F2B2F4100AA7258D9DE0B41808AFEF5D4482F4100561D0330160C410019E2AEC48F2F410000C8ADC2430C41805170D27FA22F41001C8F1F871A0C418019E26E44B42F4100541D034E110C41008BFE35E2C82F41003856910FFB0B41006E37C49CC82F4100E2003CFAC60B4180C38C1984DA2F4100C839CA25C90B4100FC1A7D47DC2F41008EABE650FE0B41006E37C4CAEA2F4100E2003C1A150C41008CFEB50CF62F410038569187E70B41006E37C4E1FB2F410072E47498A80B418036A96024F92F4100541D033C970B41C00C71B7400930410070E474A2D60A418061C60CF30E304100C639CA11FC0A410062C60C820C3041001E8F1F63260B41800C7177F70F304100385691B1630B41807E8DBE451230410070E474006E0B41400D71774A1730410074E474B4500B41807E8D3EBF1D30410072E474B0270B414062C64C23213041003A569143220B418061C60C4B2A304100561D03FA240B418045FFDAA12A304100E4003CE2D00A41C0D3E2934C3E30410000C8AD98D30A41C0D3E2934C3E304100541D03147A0A4100B71B22CB4730410070E474CA7C0A4100D4E2537447304100E2003CA2340A41409B54B04951304100E2003CA2340A414062C64CF751304100541D03C2630941009B54F021483041003856910B610941009B54F0214830410000C8AD22C90841C09A5430FA3E30410000C8AD22C90841C0D3E2934C3E3041008EABE6CC2B084180B71BA27B3530410072E47416290841809B54508F3530410070E474A9610541409B547055223041001E8F1FD960054100F0A9653B223041001E8F1F79760441009B5430CB1E304100C839CAA875044100038469ED0E30410012A2F9F073044100038469ED0E30410014A2F90C1C0441800384E93C2130410014A2F90C1C0441009167A25F21304100BC4CA48B7C034100AE2E944E25304100BC4CA48B7C0341C058D9BEB62530410084BEC006FE024100204BDB671B304100DA131648010341003C124DCB1630410014A2F92CF30241C03B12CDB01030410084BEC032CD02418022CF44DBEA2F410068F74ED6BB02410094EB8B80A02F410068F74E927302418023CFC400872F4100BE4CA4875902418077241A40372F4100DA1316E0C40141800708535DEF2E410084BEC032560141803F96B62DDA2E410086BEC06E4C014180CE79EF3CBE2E410012A2F9841A01410095EB0B7DB12E4100F6DA87A0F50041000608B369972E410068F74E35CD00418094EBCB23912E4100A285F25686004100B1B23DA5872E4100BE4C640D890041005B5D689C852E4100BE4C645D4C01418077245A0CB32E4100DA13D6BBB0014100CD79AF2FBB2E4100DA13D6631202410023CF044A862E4100BE4C64AD0F02418023CF84C5672E410030692BB3E90141803F96F669F02D4100F6DA47DCCB0141');
COMMIT;
ANALYZE "roughborough";

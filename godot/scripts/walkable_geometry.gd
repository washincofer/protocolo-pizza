class_name WalkableGeometry
extends RefCounted

# Authored against the 1672x941 backgrounds. Coordinates describe the floor
# and the projected footprint of solid scenery, not the character's head.
# WalkableCatalog adds a 12px clearance for the character's feet.
const AREAS: Dictionary = {
	"reception": {
		"floor":[[18,607],[215,542],[335,520],[805,525],[980,535],[1180,545],[1310,552],[1460,574],[1660,585],[1660,941],[18,941]],
		"spawn":[830,820],
		"obstacles":[
			{"label":"Sofás e mesa de espera","polygon":[[262,409],[505,407],[505,529],[334,538],[263,522]]},
			{"label":"Balcão da recepção e vaso","polygon":[[465,408],[802,407],[818,537],[777,562],[483,564],[465,546]]},
			{"label":"Totem e catracas","polygon":[[794,363],[886,361],[886,451],[934,451],[934,484],[973,484],[973,454],[1018,454],[1018,573],[878,573],[878,563],[794,563]]},
			{"label":"Posto de segurança","polygon":[[1024,433],[1178,433],[1178,568],[1024,568]]},
			{"label":"Elevadores e cordão da diretoria","polygon":[[1182,295],[1459,295],[1459,592],[1306,592],[1306,563],[1182,563]]},
			{"label":"Escadas e vaso à direita","polygon":[[1468,370],[1672,370],[1672,595],[1468,581]]},
			{"label":"Estátua e planta em primeiro plano","polygon":[[0,675],[272,708],[272,780],[461,793],[481,868],[433,941],[0,941]]},
			{"label":"Planta em primeiro plano à direita","polygon":[[1350,788],[1430,761],[1672,767],[1672,941],[1350,941]]}
		],
		"approaches":{"Balcão da Recepção":[650,591],"Auditório":[1535,615],"Escadas":[1535,638]}
	},
	"innovation": {
		"floor":[[18,650],[280,615],[430,596],[1030,640],[1285,645],[1440,600],[1660,635],[1660,941],[18,941]],
		"spawn":[180,780],
		"obstacles":[
			{"label":"Mesas de protótipos, cadeira e lixeira","polygon":[[280,478],[632,478],[632,505],[1040,508],[1040,659],[964,659],[964,735],[795,735],[795,716],[368,716],[368,650],[280,650]]},
			{"label":"Pufes, mesa e livros","polygon":[[1230,658],[1258,612],[1370,608],[1437,635],[1470,588],[1560,582],[1657,655],[1672,723],[1657,783],[1515,801],[1390,793],[1390,776],[1250,774],[1220,731]]},
			{"label":"Bebedouro e vasos","polygon":[[1282,446],[1434,446],[1434,659],[1290,659]]},
			{"label":"Pia e plantas à direita","polygon":[[1540,491],[1672,491],[1672,738],[1630,738],[1630,602],[1540,566]]}
		],
		"approaches":{"Óculos VR":[760,760],"Caio Brusch":[880,770],"Bernardo Nolli":[500,748],"Sala de Reunião":[1135,690],"Banheiro":[1193,790]}
	},
	"ti": {
		"floor":[[18,532],[180,490],[940,485],[1030,573],[1205,573],[1660,640],[1660,941],[18,941]],
		"spawn":[800,850],
		"obstacles":[
			{"label":"Balcão do Service Desk","polygon":[[312,443],[754,443],[754,581],[312,581]]},
			{"label":"Divisória de vidro e estações traseiras","polygon":[[747,390],[939,390],[1030,516],[1204,516],[1204,579],[1030,579],[939,499],[747,499]]},
			{"label":"Mesa de Rogério","polygon":[[1207,436],[1593,436],[1593,609],[1207,609]]},
			{"label":"Técnico, equipamentos e vasos à direita","polygon":[[1350,538],[1672,538],[1672,941],[1345,941],[1345,806],[1415,806],[1415,705],[1350,705]]},
			{"label":"Sofás, mesa e plantas à esquerda","polygon":[[0,565],[222,565],[222,675],[423,675],[423,822],[249,860],[249,941],[0,941]]}
		],
		"approaches":{"Rogério Wilco":[1260,655],"Sala de Reunião / Weekly":[1065,620],"Sala de Sistemas":[583,615],"Sala de Servidores":[800,590],"Segurança da Informação":[1290,755]}
	},
	"communication": {
		"floor":[[18,646],[366,588],[994,555],[1240,554],[1656,693],[1656,941],[18,941]],
		"spawn":[825,735],
		"obstacles":[
			{"label":"Sofá e mesas de café","polygon":[[457,477],[914,477],[914,641],[901,641],[901,676],[635,676],[635,642],[467,642]]},
			{"label":"Estante e parede do estúdio","polygon":[[626,384],[992,384],[992,567],[914,567],[914,477],[626,477]]},
			{"label":"Planejamento e vaso","polygon":[[1153,550],[1397,550],[1397,671],[1250,671],[1250,646],[1153,646]]},
			{"label":"Mesa de pebolim","polygon":[[1412,516],[1672,516],[1672,719],[1412,719]]},
			{"label":"Mesa de trabalho em primeiro plano","polygon":[[0,591],[335,591],[350,661],[406,661],[406,684],[580,684],[580,752],[733,780],[782,827],[782,941],[0,941]]},
			{"label":"Impressora, caixas, papel e vaso","polygon":[[955,684],[1175,684],[1198,773],[1375,792],[1375,941],[900,941],[875,879],[875,786],[955,753]]},
			{"label":"Pufe à direita","polygon":[[1485,660],[1672,650],[1672,941],[1450,925],[1395,859],[1405,790]]}
		],
		"approaches":{"Carimbo":[815,835],"Estúdio / Microfone":[1090,597],"Planejamento":[1230,709]}
	},
	"supplies": {
		"floor":[[18,736],[315,648],[1215,680],[1490,695],[1660,785],[1660,941],[18,941]],
		"spawn":[800,850],
		"obstacles":[
			{"label":"Balcão de compras e carrinho","polygon":[[386,579],[1193,579],[1205,808],[1087,808],[1087,829],[961,829],[961,802],[886,802],[886,778],[812,778],[812,766],[386,766]]},
			{"label":"Impressora e arquivo","polygon":[[334,516],[461,516],[461,660],[334,660]]},
			{"label":"Carrinho do almoxarifado","polygon":[[1458,580],[1672,580],[1672,827],[1516,827],[1458,795]]},
			{"label":"Mesa e plantas à esquerda","polygon":[[0,814],[625,827],[625,900],[757,900],[757,941],[0,941]]},
			{"label":"Caixas em primeiro plano","polygon":[[1232,788],[1550,809],[1550,833],[1672,815],[1672,941],[1040,941],[1040,870],[1232,835]]}
		],
		"approaches":{"Stan Leilo / Aprovação de Compras":[635,806],"Almoxarifado":[1350,753],"Três Cotações":[337,725],"Sala de Compras":[190,755],"Saída — Comunicação / Hall":[820,878]}
	},
	"hall": {
		"floor":[[18,637],[335,606],[628,594],[1068,596],[1320,620],[1660,665],[1660,941],[18,941]],
		"spawn":[840,830],
		"obstacles":[
			{"label":"Banco, vaso e mesa de espera","polygon":[[334,483],[632,483],[638,660],[554,660],[554,624],[334,624]]},
			{"label":"Painel de diretórios e jardineira","polygon":[[625,285],[1076,285],[1076,686],[625,686]]},
			{"label":"Água e lixeira","polygon":[[1095,452],[1177,452],[1177,480],[1275,480],[1275,634],[1095,634]]},
			{"label":"Vasos nas extremidades","polygon":[[0,571],[109,571],[109,647],[0,647]]},
			{"label":"Vaso na porta da Engenharia","polygon":[[1620,576],[1672,576],[1672,671],[1620,671]]}
		],
		"approaches":{"Escadas":[1110,718],"Painel de Diretórios":[840,722],"Banco de Espera":[475,686]}
	},
	"finance": {
		"floor":[[18,572],[155,510],[340,496],[1570,602],[1660,672],[1660,941],[18,941]],
		"spawn":[180,735],
		"obstacles":[
			{"label":"Mesas de atendimento","polygon":[[245,468],[369,468],[369,504],[1296,504],[1296,490],[1672,490],[1672,684],[1296,684],[1296,658],[369,658],[369,600],[245,600]]},
			{"label":"Impressora e papéis","polygon":[[305,585],[562,585],[562,721],[599,750],[558,808],[305,762]]},
			{"label":"Lixeira","polygon":[[568,754],[697,754],[697,909],[575,909]]},
			{"label":"Mesas em primeiro plano","polygon":[[779,638],[1190,638],[1190,686],[1672,686],[1672,941],[751,941],[751,820],[721,717],[779,699]]},
			{"label":"Vasos à esquerda","polygon":[[0,662],[79,662],[79,817],[0,817]]}
		],
		"approaches":{"Bruno Basco":[620,691],"Pasta de Reembolso":[698,694],"Calculadora":[749,685],"Arquivo / Carlos":[745,685],"Voltar ao Hall":[180,849]}
	},
	"engineering": {
		"floor":[[18,755],[410,664],[870,640],[1172,703],[1430,708],[1660,810],[1660,941],[18,941]],
		"spawn":[400,850],
		"obstacles":[
			{"label":"Bancada de Bento e carrinho do colete","polygon":[[500,610],[964,610],[964,581],[1173,581],[1173,792],[884,792],[884,781],[500,757]]},
			{"label":"Bancada de ferramentas","polygon":[[1172,568],[1423,568],[1423,727],[1172,727]]},
			{"label":"Cones e placa na saída","polygon":[[1464,630],[1575,520],[1640,531],[1672,657],[1672,805],[1606,805],[1606,743],[1470,743]]},
			{"label":"Planta à esquerda","polygon":[[0,811],[138,811],[138,941],[0,941]]},
			{"label":"Planta à direita","polygon":[[1434,865],[1672,845],[1672,941],[1434,941]]}
		],
		"approaches":{"Colete de Manutenção":[1215,808],"Ordem de Serviço":[1215,808],"Bento Tróti":[748,820],"Análise estrutural da pizza":[403,725],"Voltar ao Hall":[1400,775]}
	},
	"security": {
		"floor":[[18,727],[135,707],[280,648],[440,653],[580,677],[1180,677],[1180,941],[18,941]],
		"spawn":[850,890],
		"obstacles":[
			{"label":"Catracas e braços de bloqueio","polygon":[[145,545],[261,545],[261,583],[319,583],[319,549],[429,549],[429,588],[493,588],[493,553],[593,553],[593,799],[493,799],[493,658],[429,658],[429,775],[319,775],[319,645],[261,645],[261,754],[145,754]]},
			{"label":"Braço diagonal da primeira catraca","polygon":[[224,597],[243,597],[309,681],[294,701],[224,617]]},
			{"label":"Braço diagonal da segunda catraca","polygon":[[383,613],[402,613],[480,697],[463,716],[383,634]]},
			{"label":"Posto de segurança e balcão","polygon":[[573,565],[1278,565],[1278,850],[730,822],[573,801]]},
			{"label":"Esteira e detector","polygon":[[1196,744],[1297,677],[1465,643],[1465,574],[1672,574],[1672,941],[1196,941]]},
			{"label":"Lixeira e sofá em primeiro plano","polygon":[[0,796],[170,796],[170,882],[363,928],[405,941],[0,941]]}
		],
		"approaches":{"Sônia Bondes / Posto":[870,876],"Sala de Monitoramento":[980,878],"Acesso Restrito":[1140,887],"Detector / inspeção da pizza":[1140,887],"Voltar ao Hall":[840,901]}
	},
	"rh": {
		"floor":[[18,750],[200,698],[400,645],[530,650],[1100,650],[1318,650],[1658,716],[1658,941],[18,941]],
		"spawn":[800,800],
		"obstacles":[
			{"label":"Balcão de Helena","polygon":[[521,529],[1067,529],[1067,714],[521,714]]},
			{"label":"Sofá, mesa e placa de espera","polygon":[[50,526],[385,526],[385,605],[533,605],[533,713],[228,713],[228,778],[50,778]]},
			{"label":"Arquivos de ponto e cadastro","polygon":[[1145,482],[1308,482],[1308,665],[1145,665]]},
			{"label":"Balcão de terceiros","polygon":[[1340,481],[1615,481],[1615,658],[1340,658]]},
			{"label":"Copa, placas e plantas à direita","polygon":[[1360,688],[1672,688],[1672,941],[1120,941],[1120,819],[1198,784],[1198,735],[1360,735]]},
			{"label":"Mesa e cadeiras em primeiro plano","polygon":[[0,755],[258,755],[258,781],[540,782],[653,853],[720,887],[720,941],[0,941]]}
		],
		"approaches":{"Helena Folha":[748,749],"Controle de Ponto":[1120,698],"Controle paralelo / Formulários":[1225,704],"Cadastro de Terceiros":[1340,683],"Micro-ondas":[1130,761],"Voltar":[280,755]}
	},
	"documentation": {
		"floor":[[18,556],[200,534],[395,547],[610,575],[1090,594],[1230,619],[1460,626],[1660,656],[1660,941],[18,941]],
		"spawn":[850,810],
		"obstacles":[
			{"label":"Arquivo e balcão de atendimento","polygon":[[389,74],[614,74],[614,434],[1088,434],[1088,610],[584,610],[584,565],[389,553]]},
			{"label":"Totem de senhas","polygon":[[1095,321],[1184,321],[1184,609],[1095,609]]},
			{"label":"Bolota, pedestal e cordões","polygon":[[1190,475],[1525,475],[1525,631],[1190,631]]},
			{"label":"Mesas de digitalização","polygon":[[0,548],[445,548],[445,604],[617,604],[617,658],[784,714],[784,941],[0,941]]},
			{"label":"Carrinho de papéis","polygon":[[970,705],[1070,705],[1070,640],[1176,640],[1176,941],[1100,941],[970,885]]},
			{"label":"Impressora em primeiro plano","polygon":[[1168,639],[1456,639],[1477,941],[1168,941]]},
			{"label":"Parede lateral, escadas e vaso","polygon":[[1470,586],[1672,561],[1672,941],[1470,907]]}
		],
		"approaches":{"Balcão de Atendimento":[822,646],"Bolota do Jurídico":[1000,665],"Impressora / Cópias":[1000,665],"Escadas / Jurídico":[1000,665],"Voltar ao RH":[815,822]}
	},
	"legal": {
		"floor":[[18,732],[225,671],[408,667],[785,730],[894,748],[1450,748],[1656,842],[1656,941],[18,941]],
		"spawn":[650,850],
		"obstacles":[
			{"label":"Sofá e mesa de espera","polygon":[[228,494],[422,494],[422,660],[228,650]]},
			{"label":"Recepção, vaso e estátua","polygon":[[411,553],[787,553],[787,572],[917,572],[917,748],[788,748],[788,738],[411,724]]},
			{"label":"Mesa de análise jurídica","polygon":[[894,631],[1460,631],[1460,813],[894,802]]},
			{"label":"Carimbo e lixeira à direita","polygon":[[1452,675],[1672,675],[1672,941],[1518,941],[1518,874],[1452,827]]},
			{"label":"Contratos em primeiro plano","polygon":[[1080,838],[1167,801],[1505,801],[1557,882],[1557,941],[1080,941]]},
			{"label":"Plantas à esquerda","polygon":[[0,779],[244,779],[361,905],[361,941],[0,941]]}
		],
		"approaches":{"Laura Firma / Recepção":[574,758],"Telefone / chamado":[682,764],"Dr. Vítor Parecer / Mesa de Análise":[974,844],"Termos e Condições":[982,844],"Voltar à Documentação":[398,859]}
	},
	"directorate": {
		"floor":[[18,702],[218,644],[625,635],[1115,640],[1250,642],[1530,637],[1656,730],[1656,941],[18,941]],
		"spawn":[900,810],
		"obstacles":[
			{"label":"Sofá e mesa de revistas","polygon":[[227,446],[666,446],[666,610],[606,610],[606,657],[314,657],[314,626],[227,626]]},
			{"label":"Balcão de Carla","polygon":[[625,500],[1110,500],[1110,684],[625,684]]},
			{"label":"Pedestal de ideias","polygon":[[1122,486],[1243,486],[1243,683],[1122,683]]},
			{"label":"Água, vasos e mesa lateral","polygon":[[1510,592],[1672,592],[1672,884],[1580,884],[1580,836],[1510,836]]},
			{"label":"Livros e mesa em primeiro plano","polygon":[[0,774],[315,774],[315,840],[534,840],[534,941],[0,941]]}
		],
		"approaches":{"Carla Agenda / Secretaria":[876,726],"Gabinete do Diretor":[1385,677],"Revistas":[420,691],"Voltar ao Jurídico":[571,886]}
	},
	"reception_waiting_room": {
		"floor":[[18,776],[310,640],[966,594],[1200,637],[1495,679],[1660,731],[1660,941],[18,941]],
		"spawn":[835,820],
		"obstacles":[
			{"label":"Sofá de visitantes e mochila","polygon":[[315,408],[951,408],[951,647],[315,647]]},
			{"label":"Mesa de revistas","polygon":[[378,563],[809,563],[809,709],[378,709]]},
			{"label":"Revisteiro","polygon":[[18,370],[291,370],[346,765],[18,788]]},
			{"label":"Água, lixeira e posto de segurança","polygon":[[1010,410],[1114,410],[1114,445],[1468,445],[1468,674],[1200,650],[1100,650],[1100,610],[1010,610]]},
			{"label":"Plantas em primeiro plano","polygon":[[0,801],[252,801],[252,941],[0,941]]},
			{"label":"Planta à direita","polygon":[[1420,771],[1672,697],[1672,941],[1420,941]]}
		],
		"approaches":{"Visitantes esperando":[626,752],"Máquina de Água":[1030,675],"Voltar à Recepção":[1514,714]}
	},
	"reception_auditorium": {
		"floor":[[18,670],[1270,670],[1270,495],[1505,512],[1655,570],[1655,941],[18,941]],
		"spawn":[1370,800],
		"obstacles":[
			{"label":"Fileiras de cadeiras e palco","polygon":[[0,426],[1273,426],[1273,670],[0,670]]},
			{"label":"Mesa de café","polygon":[[0,548],[278,548],[278,718],[0,718]]},
			{"label":"Lúcia no corredor","polygon":[[1235,665],[1356,665],[1393,755],[1240,749]]},
			{"label":"Livros e plantas à esquerda","polygon":[[0,720],[304,720],[397,795],[397,941],[0,941]]},
			{"label":"Mesa e bolsas à direita","polygon":[[1430,773],[1672,773],[1672,941],[1430,941]]}
		],
		"approaches":{"Lúcia Pauta":[1400,758],"Púlpito da apresentação":[1410,577],"Voltar à Recepção":[1445,553]}
	},
	"innovation_meeting_room": {
		"floor":[[18,624],[276,609],[452,598],[1470,620],[1656,697],[1656,941],[18,941]],
		"spawn":[450,780],
		"obstacles":[
			{"label":"Mesa de reunião","polygon":[[550,503],[1498,532],[1498,748],[1080,837],[755,783],[550,704]]},
			{"label":"Cadeira à esquerda","polygon":[[539,539],[699,539],[747,749],[725,820],[546,820]]},
			{"label":"Cadeira central","polygon":[[821,580],[1015,580],[1055,796],[1038,895],[814,895]]},
			{"label":"Cadeira à direita","polygon":[[1197,575],[1373,575],[1430,738],[1403,857],[1125,857],[1125,746]]},
			{"label":"Pufes e quadro à direita","polygon":[[1450,391],[1672,391],[1672,696],[1460,696]]},
			{"label":"Café e apresentador","polygon":[[282,423],[460,423],[460,480],[550,480],[550,655],[455,655],[455,608],[282,608]]},
			{"label":"Caixas e mesa em primeiro plano","polygon":[[0,681],[301,681],[301,805],[412,805],[412,941],[0,941]]}
		],
		"approaches":{"Reunião de inovação":[484,727],"Quadro de ideias":[1518,742],"Voltar à Inovação":[207,669]}
	},
	"ti_server_room": {
		"floor":[[18,699],[310,670],[447,685],[1030,653],[1360,744],[1656,778],[1656,941],[18,941]],
		"spawn":[800,830],
		"obstacles":[
			{"label":"Racks","polygon":[[447,190],[1115,245],[1115,650],[447,682]]},
			{"label":"Mesa de monitoramento e cadeira","polygon":[[1020,551],[1070,551],[1070,506],[1190,506],[1246,587],[1480,587],[1480,785],[1255,785],[1255,797],[1072,797],[1072,710],[1020,710]]},
			{"label":"Caixas, nobreak e cabos à direita","polygon":[[1310,783],[1375,783],[1375,650],[1672,650],[1672,941],[1310,941]]},
			{"label":"Ferramentas à esquerda","polygon":[[0,678],[219,740],[219,821],[377,849],[501,891],[501,941],[0,941]]}
		],
		"approaches":{"Racks de servidores":[777,736],"Painel crítico":[1000,839],"Terminal Pizza as a Service":[800,736],"Voltar à TI":[292,772]}
	},
	"ti_service_desk": {
		"floor":[[18,693],[275,616],[1155,676],[1250,540],[1455,580],[1656,777],[1656,941],[18,941]],
		"spawn":[850,810],
		"obstacles":[
			{"label":"Balcão de atendimento","polygon":[[510,474],[1159,474],[1159,686],[510,674]]},
			{"label":"Totem e lixeira","polygon":[[296,318],[434,318],[434,517],[508,517],[508,664],[296,668]]},
			{"label":"Cordões da fila e bases","polygon":[[1204,498],[1245,498],[1465,738],[1465,818],[1350,818],[1285,724],[1230,661],[1204,609]]},
			{"label":"Sofás, mesa e plantas à esquerda","polygon":[[0,680],[145,680],[145,739],[397,739],[408,941],[0,941]]},
			{"label":"Planta à direita","polygon":[[1540,739],[1672,739],[1672,886],[1540,886]]}
		],
		"approaches":{"Samir Maxo":[789,721],"Fila de chamados":[1162,775],"Voltar à TI":[217,714]}
	},
	"rh_time_control": {
		"floor":[[18,784],[122,704],[327,610],[695,591],[1266,640],[1480,640],[1656,813],[1656,941],[18,941]],
		"spawn":[835,810],
		"obstacles":[
			{"label":"Sofá e mesa lateral","polygon":[[110,445],[329,445],[329,479],[411,479],[411,611],[329,611],[329,702],[110,702]]},
			{"label":"Relógio de ponto e lixeira","polygon":[[430,394],[570,394],[570,490],[669,490],[669,629],[570,629],[570,616],[430,616]]},
			{"label":"Balcão de controle de ponto","polygon":[[695,493],[1274,493],[1274,714],[695,714]]},
			{"label":"Planta e café à direita","polygon":[[1464,419],[1546,419],[1546,532],[1672,532],[1672,818],[1520,788],[1520,660],[1464,660]]},
			{"label":"Plantas à esquerda","polygon":[[0,782],[260,820],[260,941],[0,941]]},
			{"label":"Plantas à direita","polygon":[[1480,866],[1672,806],[1672,941],[1480,941]]}
		],
		"approaches":{"Paulo Pontes":[945,753],"Controle paralelo":[779,753],"Voltar ao RH":[1365,685]}
	},
	"rh_third_party_registration": {
		"floor":[[18,641],[314,546],[824,624],[1318,742],[1656,837],[1656,941],[18,941]],
		"spawn":[820,820],
		"obstacles":[
			{"label":"Balcão de cadastro","polygon":[[309,448],[839,448],[839,658],[309,645]]},
			{"label":"Bancada de documentos","polygon":[[828,478],[1370,509],[1370,758],[828,683]]},
			{"label":"Copa e lixeira","polygon":[[1365,518],[1672,554],[1672,844],[1560,844],[1560,811],[1365,803]]},
			{"label":"Mesa e cadeiras à esquerda","polygon":[[0,627],[215,627],[215,674],[254,674],[254,680],[392,680],[429,826],[429,941],[0,941]]}
		],
		"approaches":{"Caio Dastro":[584,712],"Formulários de cadastro":[779,723],"Voltar ao RH":[254,626]}
	},
	"documentation_archive_reprography": {
		"floor":[[18,748],[410,710],[619,630],[821,641],[1314,702],[1388,651],[1465,643],[1656,889],[1656,941],[18,941]],
		"spawn":[1050,820],
		"obstacles":[
			{"label":"Impressora e carrinho de papéis","polygon":[[18,334],[407,334],[407,495],[619,495],[619,732],[407,732],[407,744],[18,744]]},
			{"label":"Estantes de arquivo","polygon":[[507,129],[932,129],[932,627],[507,627]]},
			{"label":"Balcão de reprografia","polygon":[[827,475],[1352,475],[1352,678],[1277,711],[827,668]]},
			{"label":"Carrinho de caixas à direita","polygon":[[1463,546],[1672,546],[1672,941],[1463,860]]},
			{"label":"Processos e planta em primeiro plano","polygon":[[0,729],[467,774],[573,871],[720,871],[754,941],[0,941]]}
		],
		"approaches":{"Domingos Hurley":[975,753],"Impressora / Scanner":[680,733],"Voltar à Documentação":[1415,727]}
	}
}

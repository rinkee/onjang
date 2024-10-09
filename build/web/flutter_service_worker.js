'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "ec64df87be8472e65c9c09072e46c4d0",
"version.json": "8d32b9ea53dd383ede681897dfaa47cf",
"index.html": "7b7768ad222f22d987a7d46dc5710d4f",
"/": "7b7768ad222f22d987a7d46dc5710d4f",
"CNAME": "13515ccb478ed8b21537d83e60956cf3",
"main.dart.js": "e29e2a3563f2e5567cdb070cbf681ed2",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "cea054b9a2a41e6039aaef5d3c31701b",
".git/REBASE_HEAD": "efbeb925d4cd16988dcbd4d77c8a73c4",
".git/ORIG_HEAD": "aeb547918a46e75a17e9ba9032990cf7",
".git/config": "d58ccf5ecdbcb56be28dda011906bc99",
".git/objects/61/03313eeb02ade32d1f6f035adc459c65d5c53c": "4c2e0361f091a3e00e7c5e4fd6f536b9",
".git/objects/61/af33b77cda8cfc445df97ca704719a8f50d7bf": "6337d5136c2ef7124286aebd251f08bc",
".git/objects/95/b7659ff8ea55d40fedd2c20b9dc2a5a5d9bc1e": "dc3c2a075cc2f04a4e3eddb972f4cc3f",
".git/objects/3e/ba4fc7a4029a687033387653c245117b6b8a64": "c6e8d1dfec5d4fc3fc4a5f33ebd8a8ea",
".git/objects/3e/7cf8185a721a39982e377ba3291e033fd8635e": "ce654c251bd55de8cc67f6695576f72e",
".git/objects/3e/8395ee842a37febe569785ea05781081b15f88": "a9e4972fa1e050a0ce8857a1b45e2f5e",
".git/objects/68/dc59c3de8f4cfb3b7280c96188522c7297eafc": "0de9c94a1ba9504ad545ab0646366410",
".git/objects/57/8322e2b8da90f8efeadff7f2d163a606754a07": "40f3cd601c206b7c50255096145cf198",
".git/objects/57/54fadc9d4f3e89aab9e3f73969c37e97319001": "07033933df07c6f4ad872343713476e7",
".git/objects/3b/4953c7602b5b77d4a4f33d943753841e881139": "69004ffdd806e783db8e358a39f945c4",
".git/objects/6f/d85ba770c403bdc8cc1119795dff1eb9397797": "e8e72fb4020d318900760b8f8a6aaa19",
".git/objects/6f/5c030e6446d14d02d2a2ef973399968cd40e8c": "f8dd0dd961e30c2efba21db0f2433699",
".git/objects/9b/a7cbcba029ce6dd9082a2118ea8963890bff7c": "a2c9401dbeca4a147b1f9375d004531f",
".git/objects/9b/16ed8ef77b36d0a1c951e4463f538d84bd656e": "b958bdf568234c9e65b88aae21230b3f",
".git/objects/9e/15ea48267a699cf112aa7a57e34178d96c7e6a": "4e5bbfddb5dd6cd16ef49b020064a2a8",
".git/objects/32/4d598a6c2d2550a02d27b0552aaff2d2866865": "724cd3630fca614f9ab961ad157bdb3f",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/35/a94438b63678cf29ef3b70c9f8a9c655c82528": "f0869729268cc55f5e46b4ea4b75d76f",
".git/objects/69/0bfc61a081f8dbfc8da384a2879a2a041dabdd": "5a0891072c99514867caaaa2a051ff05",
".git/objects/51/9c209cfb30c49f925f9af091f6d5c3f61a4a34": "3296bcd968c376bfd52ba1087a877280",
".git/objects/51/46f1586a50c2701b77806faa96a307d504615b": "d6dbf6d71fdddf38ea15ce23cebc3fed",
".git/objects/3d/7076705716bda0283471fedf8e095e3bda8b74": "545bcb2772abccc5f774178aa8d93cc1",
".git/objects/58/ac30b54deac566b9bcbc2a5e6dc6e0498a95ba": "f22b455dc467ddafed092c2ec6f67aa5",
".git/objects/67/1bfc42568165033a410c67da10e49eb113653d": "148a2901ae4ee8e90cc1b54ba50e56aa",
".git/objects/0e/a0a8f33482a4f1e95c40ba006f194e267d507f": "81ee86e3a92e08f0a889908f86c68382",
".git/objects/0e/64d4f6614c2406335a63f9e655ffe5560cb113": "13370bfbf3a9e651f8fbc54dad0193c8",
".git/objects/0e/7b7e21bb3d831c09fda8c951460962feada12a": "ce13825ae4c023a567967c1852f4cd3a",
".git/objects/60/cb05f1c4479dfd571fba24f35022d4d1e8c085": "19e07c55040364d366c62733c2a41c1a",
".git/objects/60/3fc13dc0d838d9a32277f2e13a6ac8b737313f": "51b3c0c3354e49e8dba4dbcc8068911b",
".git/objects/34/831a8fc32443d04f9d00c1cd6afd34b7b0a89c": "a59d65b18a5bf578cf9296dcecdf5991",
".git/objects/34/ea9cc8e7687a83ea42786f3cc1afac735a3eaf": "a448b5f38281e8fb33ca25530a912356",
".git/objects/5a/3bdc29cd1e72971852056388eb514fc2e1cd47": "8a6544c3f63d1fc380423bbd412d5b89",
".git/objects/5a/420a1e2677d3c9ca51a872a46b502da4ab2387": "039ae38360da04c4e27fd585f8506a1a",
".git/objects/33/07f3abd4d6a6cf04052bbd4630e39d56594d7d": "c1729b18e488e62df8d56f2cd73f0efd",
".git/objects/9d/6c270ffa61fbf0e0207d67a521c17d13a80945": "89727b03d0153760cc47704bd0103a75",
".git/objects/a3/832d6740eef3f45d537299f7326ccb5110ecb5": "8ee13e01a1cd843c73d6534c1f94228e",
".git/objects/a3/a863bc9ff1af79fa1e98483d79776f96f9bb35": "e4992ed9057801ed3001c65d12201c9d",
".git/objects/b5/e38496c44aba6a0e19928f98fd7ed9e65ac835": "28b4b8eef94d79d55a6062c40da4c84b",
".git/objects/d9/1f0e01bb6034c39c82ad07b66818c5ad761a66": "767a451af5c87811b5c636b21fbfea8b",
".git/objects/d9/8561c48d7bd8870b2d6829b255e0dea7825ed6": "e627eee642316a23acf96295831b7131",
".git/objects/ac/121f857929daac57294798c303d9fb769395a5": "8c9734700b632fd72a3bd099a3ad328e",
".git/objects/ac/2da6961949ceba3d0b9b0c9023bef887be9526": "3ea183bf76ba29fe4ed6f2f09f015189",
".git/objects/ad/377d35c4f4d7bf92c4f754ac67aca43f36cf82": "5b3a89c44ec2d71e06fbb2b37ff315fe",
".git/objects/d7/1a9dbe15edf926a63e7184ef3e971569c5b630": "2b5594a596082f54ed35274cdb32736e",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/be/ab9aa205b04db1c3e5c47b1e7cf2c27868f011": "9be4f7322bbbbac8c49c9b3aa25c584c",
".git/objects/be/9f9f6d8ecd9a9bbc771bb859643572f7b37037": "67406a17d5f2983bc4f19a68a3392a94",
".git/objects/b3/bf2d6b88bf9e1c04a994167b1882c77951076d": "8de467f022c59d64ba75d0b430955e24",
".git/objects/df/4214f6441e52f8abf2e8d570912839bf615222": "053b8e42882da9db869b780e285ed28c",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/cdaa751976eecb32c02d7b52bd1377f15e0dd8": "6d4f936795e9c371468238d236d41340",
".git/objects/d8/969662854680bde14fca38d12b4652ea322df6": "6044414a623ffa797b7b41bf08de8a58",
".git/objects/ab/e67942121ef8a6f4aa052d8af8df0ff65881a1": "38b44552bd74840e6e250002f698eeac",
".git/objects/e2/150fb2cafad940bc4db75873b2f4a650dfa70e": "ed16534b54243df7887ff9fccefaa1aa",
".git/objects/f3/c87ecff13545f62272a63013df002628d2e4d9": "798cf3be1b186f9e255bbb46b6d7ba0f",
".git/objects/f3/809a43016af50e9aeba27c3dc70c43061ee7a6": "60e30e81507682c22146e626725ee36c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/c7/8d02c1bdd92ebf83a26f11b5f13c8d13cb697c": "e56644afff07b95f76674fff4555b001",
".git/objects/c0/af64eeaecdd6d856e89e76bc7d10841906eab1": "c8c57b36336a71e6b835f48f539ea6b7",
".git/objects/c0/9897d1af3e5a61dcad13e156360856eba95cb1": "2a0f39dff7bfefb459c1a2b01bed5782",
".git/objects/c9/66aeeb721c7b4c90f5ad35c673c6a9681aa565": "5ec25aa7897e85cc1ba54298e5013c43",
".git/objects/c9/9055fd2a845ca57d689288d59e56c364d37739": "beafba6c90a0cef1be7ef7707e254db9",
".git/objects/c9/185a0e2ccbb2328b0b42c9ce1db132574a1d95": "485505c30f7f34c10c71b8977a269ddb",
".git/objects/c9/5509b9cf94716655786d94084e518b4c8214f0": "0645a039ac53fd73bd14f70880505e7a",
".git/objects/fd/287cce872b5e0a03e3cd88f55463d6e3fecedf": "d70126dd5a3174ce075e524020e75cd8",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/e356e9f32720fadf61c3810e2d1c821623939d": "d99c374f40cb0aaed52157418bf6a438",
".git/objects/f2/bb96c802f9b4aac3a42f550b6a2d60adc92306": "055282765f21977c9158ed613e14a8e3",
".git/objects/f5/7d4c38894339e3d986278684683e0a3be244c4": "6729fb96072fafe4954f732b1ae5b44f",
".git/objects/e3/5cb004a361db7739f94b23badda05f69f50568": "bc048331c75d9fa3b2ffbfe36c21379b",
".git/objects/cf/cb79975e762cb7bdfa709c035107368448a15e": "93ae5fc26f6d9f9a0915ed8a368680d5",
".git/objects/cf/c135744ad4e7955e61d1a41d2057e379e9622c": "a89089c3b82190dd18d0477c221bf1bf",
".git/objects/fe/049bbe2a9b78ad702bb7452e18e25246a676a9": "7f549a94dc69a0d670863a5787b5d0c3",
".git/objects/fe/ffede7fdf735d2e2c6982523e9381bcf1f0cf8": "ff903341a28ad0fa5a59b339ee744517",
".git/objects/c8/ac0482a9cd7e7e195cde7c8ccd359473414a6a": "7d6a028906ad3a03c5f3d424dc028f14",
".git/objects/c8/6457a51d80d1a9ee7eb157106f23c29735d2cf": "bad688260949f06402006a1aed6c8737",
".git/objects/fb/684bb37e95b5603e5caf230d1433a35b5936f8": "303c78ff8de0fd39f2f3d8bce4a80afc",
".git/objects/fb/3c5f63d3db84ad540ac6d45919d1c176adfb1b": "9fbdb22ed619f238e0129ee60305d9d8",
".git/objects/ed/3913155a13223875800dc59024ad2273b4fdc6": "ab86fe251596bee39a88e42485ffd535",
".git/objects/ed/5b268295666fd0fe69fbc4ed90b785dee03397": "071309640e0eb9c8b1215e54afba789b",
".git/objects/c1/03740d6db3a7b06da16f1c4777f4167552e9e5": "9ad45933c30d1ee8173dba5af1e23adf",
".git/objects/c6/6f3dc1620f086e8915cf1f340ad68f875fd062": "97aca497b6a559d95437a1ec0751f439",
".git/objects/4e/b81accfae21e0798a4471fb7fdcddb3ecde3b9": "25fef67082f159ec4f5113b0f085d6bf",
".git/objects/4e/81d224e636072c373abce59620480906be5aea": "223236fe1f86476a4cb6b9aa6efa9df7",
".git/objects/20/834911edb84129b91ccc1954d92ed44dc55d82": "659f0e306f0aae530951c51a5e7030c9",
".git/objects/18/cf27a62636d20215120f3c140f7662794dbecd": "058ab973c557081a3b7d6de921ebfb82",
".git/objects/27/ff112553a0b422e55f1f52d4a886bcff5e667b": "cb9142058f397c1f17b05253a4c8208f",
".git/objects/27/5d5e5193fcf0c0fc48061dbd7d89f886f9565c": "39b31e4ed7409a55d4f2b869a485c640",
".git/objects/4b/55a66b753d3bb2f4d57eaed2c1e6908538c007": "ffae8327a2e653306b8d4905d4bedaf2",
".git/objects/4b/17e71929bfab687a85da65c7ac3b6406c399b5": "2e394a0839ada54156c396e88edfe33d",
".git/objects/pack/pack-5de4def18e607b731a584c49bc11d78c091378e6.idx": "85944ee2a0d8c5de893cf8816a2860cd",
".git/objects/pack/tmp_pack_KzaiXf": "16c848f9f2ef5f1dab183233867b96e2",
".git/objects/pack/pack-ea8155b0209ae25f4b72e2e0e41879892eb811f1.idx": "8ac6cf7560555fd9ebf6ec6f2d0267ac",
".git/objects/pack/pack-ea8155b0209ae25f4b72e2e0e41879892eb811f1.pack": "e616116b040ab847e8b979f096d89fb4",
".git/objects/pack/tmp_pack_BycwzC": "5272b05a1d6fe346dafbfddff80f6b8a",
".git/objects/pack/pack-5de4def18e607b731a584c49bc11d78c091378e6.pack": "caf0e43b524adc5a41c03226f5fd2e53",
".git/objects/7c/e9c62c22bd2c6cca2f31dc565e8b34eda9e09c": "69eb1b18215d0bc842f638484daf0174",
".git/objects/42/c27b2dcc19203012db5dbf3867a57af21ef5e4": "f42a058856418624f2744ad46618d9f0",
".git/objects/89/0d722e4077999406324e003c1b61c8cb09f981": "0f1ff0531f1307fe2f850731a6356e24",
".git/objects/89/afd8c9aca52ba781ef9998f90e1a348e3aec3e": "f84cc2184b58e32866af99bb4ce7a979",
".git/objects/45/c57a2e19dd64878dbc78fa6859b3d9de57caa3": "aab9e1a611a6028d37bf55397f5f47c6",
".git/objects/45/d6682abb6f33967a3c38a8124fa311f4710ef0": "c7a61edaa7f1ccf2c8c38dce8f58399e",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/87/b9eee89d69e96ed576275736be85be0968c6d2": "f13d30bbd9d07059a9ea4ca620ef9687",
".git/objects/74/150c61ea6530ce247aed874825b7d364641759": "486b779208b86806e3c991237d41a910",
".git/objects/1a/7209f597c1d4ffac0f0800c92235e9583d2120": "da58c9a03afc5eb3db48b86a6a6c1375",
".git/objects/28/8f056858ba2c6f788d022a7fa5ec4a31f8ec55": "7e5a163fb2093a0f4b26d87d6722d0a2",
".git/objects/7b/ef8e15cc15739ae04f3732ff20955ab98c2486": "fe77e3cf304fc2d9864a7fa33d87600c",
".git/objects/7b/98ad57e0ee27a0faab147ba35b22aae2f8bc23": "6cf784f5a07a1804bf64a49ce2c0dfac",
".git/objects/8f/f3c6a27aa64d85b58015effa5f56f086f7afb2": "8f0b888b6eb5df18040a39e76b096026",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/7e/2f8c39ae448aed01065a750ee53629dd04fdb6": "8a56469533c887d8bfc38bdac910d2b1",
".git/objects/10/ade3b4754c7470e47c6b6ecde5665e7d58ca80": "688c908a8ec31ab92d9f88787293745a",
".git/objects/19/75d7a843a3856a90538ca70fdf752f9046cb84": "b5c53bff91f2bc3103c8802330352e4b",
".git/objects/26/1dc7bc92789b731cae4b08ed3b3af62ba62d72": "333a07a203ee724817a415f6bf0b10a8",
".git/objects/21/7c169d8012a05b7ac0c9da273040b390f9c869": "53053f8cc9dc06e0f796e33f941bdcd4",
".git/objects/4d/2ccecf2bafedfb1db8217868faa01233a7355f": "08b5b74125f0b7dde34594919be5c1ae",
".git/objects/4d/2f8db5d162dcde6c9ad295d5f7d9ef5b66e982": "6468d035239021ba53fcf02fbcd84cca",
".git/objects/81/54c4862cb4ba832466424fe740c153694a0bf0": "df6ed027631a65e9f83d596199568043",
".git/objects/81/55c5251fb55b1a2d6c5def13ca7f7acd2d8834": "379e9716de02a63feb41f131250e6aaf",
".git/objects/72/b1c4a18e3cb4825b01706172af3f5e352f3ae3": "c4bcdf14359580004c27313b9f2fd7e6",
".git/objects/72/93488f4c1b5e845bd5358d6e3a3534abea4fe4": "cd7259dfeddefe3701788168d4344580",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/2a/0760ceff01aafe89229c89627ac7dae4a5c1a2": "19f25dab911b5de63769342a17f58a6e",
".git/objects/2f/1abda36278296421b9a63580d105243df3fdb0": "89cec97c83f5d57b6a7aa7afd7e5982e",
".git/objects/43/72734de5bc5bbd0476b2eeb7a493d5e2b6c534": "b2e09fdab6020cbdc65904c6da1a7018",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/9f/cc1c19df106070d12144a28261e267556d4912": "cee4815be12511ac92675e9e8b30f8e7",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/6e/9b341915fb1694a276e5a49be9ccae505a49b4": "8c0e7f7139e894075d418901de7c7c34",
".git/objects/9a/123c22083f2df792c7c054fed9f3b268002a0c": "afc7a07547ca45d61bec9e72449b1c5c",
".git/objects/9a/f86a64820699bc9907710326a2f82c2cea70e5": "1bc16e34ac8647987add2fd9be55dd38",
".git/objects/9a/010d4dbd836cc4e867b01c44fa30acfde16e83": "4d60e0c669fa5c7609d53656703180e2",
".git/objects/5d/b8e9a259abdf264ad6d6aa1e5e9f92ce7a5b8f": "b874824709cf4321965d076ed7b912ce",
".git/objects/31/83a82476208791bf41af444089ad7b1bcb49a2": "d4e9c546e2d045b6d630415f4012fc25",
".git/objects/31/b8ceb7958b9401f9fea5c2d4760d4516f85197": "e11ae34e157e9b19dffe0c06810673d0",
".git/objects/62/84ef5d929a68a3cab2c908d9f0c01dae91b4ad": "ed8496fdb5fed348bb2e4979b19bd6e9",
".git/objects/96/6736332a02ce1a98cec82bc26d1746d44208ce": "0df418de5445957ec77e4ba9e0ff9cc9",
".git/objects/3a/3beadd1f59ed1a7c194f9f60e81b9d3d5a6654": "8056ecd3f3a6eb1296311ece57833bf6",
".git/objects/3a/f6dce4d10cc9201d6a4aa3d5a0bb50a63c7d07": "d3e13e4e267b204684b47e111695eca8",
".git/objects/3a/a56b1c9f64566544034e7da4da67379a8205bf": "9094552d72f871eaeb93cb4655b5b28b",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/54/54dc1718759df685145e947821b5b7d1ed3dfd": "ab9aaed77bc4cd16b8991ebd1aa92fa4",
".git/objects/98/3bdd8a87d36bf63db24b5b0ebd1c7fefd4f7a8": "da2d1cfafc74abc5a123e524ac75c9d4",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/5b/1cb50d67a7f8ab76920156984227aafe8ebb62": "809ef93d6dced95f6288188632cf8515",
".git/objects/08/7d6fb772fb09cefa1c09dcbdc8f0f3a800bc8b": "fa0af038fd59f380dc5b69f790c83012",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/6d/dfbdd8c0a3da7c793e0c6b85b7b376186d6a0d": "a5d85d620a356483ab83a4310415df3d",
".git/objects/01/1647ee7ece19a20768c1115a8bfeb728fa08e2": "dd192c7dcced286c7c738f5d831807c7",
".git/objects/6c/07bcf60e91f3fc7155e751535313e09c85123a": "c2fe07f044b74e595453659911e7f807",
".git/objects/39/f5a5baf7110671bdb376bbda98f631f5fd5517": "547c4348a515e6a1e6f04a414e321cc9",
".git/objects/39/ea18dd716d28ef4453b66f1864dedf2f3f3131": "0a1f59f65dc7d095c2a3cffb00e123d1",
".git/objects/52/a323a217e4e468f6f19c76577a171c9abe52fc": "8ed18266f37644883290021101d1b488",
".git/objects/52/9b20bfe1285b82fac3950c48485dd14811df49": "af3b1e1ad884f2d8150e8acc3bc34c91",
".git/objects/52/be0d8a20aa4d5860da357d3e03275459f442d2": "9935b17f0d6b8606cbcb1364bcf83dbc",
".git/objects/55/0c76746a1483c0f3bdac33ba82d43c7a0cc929": "65da66d4deb4d1a5e492e3cb386705b1",
".git/objects/97/2e1efed862429591ba2102a7fc72a3d766fa1c": "76f5168c18a61d658962501faac67d90",
".git/objects/0f/e41a60e85f3ef8ddc019e4bf98acdb412d2a4c": "8dbe13d769239bba578c3eac8e941fae",
".git/objects/64/d43044ca8324ffb20e20eeff47f5c6b4d5bdc4": "15e9cb08dab5424daa34036523338c3e",
".git/objects/90/073ebced57513a9375e839a0dd4857ebeef47b": "2ca5a50d97c4191977b2cbb43efbfc2f",
".git/objects/90/57c14aa8d3b22ab1c4dd2e828f0651f00b8e7a": "9f44a9255ece65d6db61bf868941077b",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/d3/d87a98fe916b5ae3cb4e3fffd3ca8a78d0a6d8": "5f86d8c754cf4ddd7dac9741fe9bd0e5",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/7fc8f75e91d7031832a11726d141ad899c9eb9": "295a43d0f8d3915883bbd0906682c282",
".git/objects/d4/f0d9ae725bce40a2e39dfecfa9666332226b45": "4aadf41b57863bcb029d0bb393452621",
".git/objects/ba/1aae1c40a61a8304f489bb6b237a6e60ab5150": "680517bafb995b182fdd2c3f10bbc4f9",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/a7/7e569ad861952865a0c600bd51b8a05bf8d0ba": "f9b9b72de77ca40beee97291ce84148c",
".git/objects/b8/0d007e669cf5387cc000b94f66d0615f48ed75": "7b6be3b4e56bfcf644e5778ecdb328e8",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/f10037d898ff35fa28256da1b9e16fb6e6d26b": "ca3c667a1403492adc28de30872827b0",
".git/objects/dd/b4406037c4d2b590203a7e30b40fd6819f44fe": "f9540bb3bde803554bdca64b7cd0d91e",
".git/objects/dd/f884aec9368bd23af4a2c6a3b5a71c8de28007": "cee1c0a0f2d1e473b4148118ea79d110",
".git/objects/a9/1124d610a1ed2798c5361caec37ff54beb94d2": "17367fc26eb0c94de617defdefc54425",
".git/objects/d2/a74f77e32f5258a6f1b4d874b6c2f687f41433": "3191076a353a66a1293fe763e9fff27e",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/2cde84173b90b2fb57ac9fb57dfd253951155b": "d0e4db01346b5b6e29224883bb9a04f9",
".git/objects/db/6a3b40083bfa9433a3d9928e279ffa887ac3b5": "ab8a512d8601397598f1c6ff4d17a60a",
".git/objects/de/c0b11c40235b8b2dc0e2bc745e57eb7998f642": "4c793430f2b74366e31a437f65ce4d18",
".git/objects/b0/23ad3d8f532f18b80662139e9b01b2cb011cce": "d1c6e2d4d375ee8609c02ae27b78952e",
".git/objects/a1/83dee748ffff86cc62d0f939bfc6158f1ad862": "9a8e7bf9bfef9eeec8343343ce35b0c6",
".git/objects/ef/626251c0a914dfc9e6bd5b0259c568261731b9": "c4423e55a1f7f506a2b0fbb1b9b6af4d",
".git/objects/c4/cdc89333e08fa1b2fdcf5724201373ae552f6b": "16d76b92d4480426e2c9d9071e0273e1",
".git/objects/c4/6ef8ebf4ae7fdcc09e93d29d48cd196bd91f92": "291f2039daad751a939d99de68994f53",
".git/objects/c4/62891a102049d3ef622e5726f1724aaf9458ce": "42e80624c8729c6d3f31ac9df2398048",
".git/objects/ea/f54ad5c3a6980f6c55b452f5ad5d94bbed3d54": "89e18ce967320ef06fa013f8085fb666",
".git/objects/e1/9806e3bac017a41208154a91ac4b5827eff8b9": "96fd66c766f007c42d23c557faf1b11a",
".git/objects/cd/c57155520bd3f32ac789d032b821919d8ccb8f": "9ce26ee105588b0117900c2e98bcacda",
".git/objects/cd/01974d561b2798120852c89db02ccb957c3306": "537337baa5fa7d9056f1c8cf6a5d66e4",
".git/objects/cc/2155f060a1feae822d87b609898ad002570a11": "875a5a26719790b0e2161e84e8de14c2",
".git/objects/f9/a9cd079adb2930d2a99cc87648bb8b1461afbc": "3c0efb344c22b0c44943ecceb06d2b63",
".git/objects/f7/e03ee169230ddd4b96fc8d006facf2677fc615": "5e50b6b622df25481e96698a2ef799cb",
".git/objects/e8/eae671337fc4b55b473fff2c872e5ab056cdc6": "c9d3951fa7589172507d73095e0f7db1",
".git/objects/fa/f6c3d8d88b46161eee196c31a030d19dcc41bd": "2dc3a5e09ca9ca8b85bd90f3f8f7b116",
".git/objects/ff/ebc296d05e756a5ac824663da79ad504c9f245": "0e69e98cb6fa05193c096916511a0d52",
".git/objects/c5/6c6725376d64d07cccbded6619203c5c5219ff": "0b5031a49c96d190c198266c52258838",
".git/objects/c5/0048597d2564c454882578867495cc259b3104": "55d804c3b878594be5732fc4eca073ef",
".git/objects/c2/640a19e62594b1706ee8c853fd0fdacdca9ab5": "6efb7e3fa4aab1dc4555ae2ab0ce0aa2",
".git/objects/f6/81bd762fda5df026e1a6b735564c419179dab9": "ff1edc64fb32eabfb70981fc8c9b9d04",
".git/objects/f6/3a5464b4693574f7761c1f89b9a5fd4c4d5b9a": "42b1e17707ac837dfd328ebea710ac86",
".git/objects/f6/f6cf902633c582ed1b0ae59ee250fd9eceea1a": "1020ea15926831a7e9533c97903d6969",
".git/objects/e9/ddce6c72723ba33436054596bd50aa1046e038": "0b757c6520a1cfce80376edcc0da4a21",
".git/objects/e9/c3e7618d7b5ad7286c32e41f8cb30671ce0de3": "aac66147832f879c16c86e0163a0913c",
".git/objects/e9/dfeb973a496a9ce7767e4fd0147222cfbd0f22": "51d92e51d27a0326eda7c99221584201",
".git/objects/f1/1122eb8c4105a8a8ebae9e69adcf2f7271b678": "2f3548036dc2e5ae9707c5ed2da8b1ac",
".git/objects/e7/af4072169d226a01b01683bbca1cb382d44247": "7bd9f20464934ffd731b7cd4e0166742",
".git/objects/ce/ad803a6c6d0b32427cfca672b648c6ed95aa0a": "8e4d82917dcc2a1ad0ba6aedf2d6c5af",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/46/643ae0539b734a4d53567bc7385b769143caca": "048caa8d5723456f1b121ee3e0cf024e",
".git/objects/46/ff0aac9e54ea5e2eb45e16963fddda47f6fe92": "022bf44d6a51c020ba161b4eb05a29ba",
".git/objects/46/c3966d5390e6b1e0e968e4bbd7321e8321b0df": "6dad09461ff54fc48c57288e7ec3cad7",
".git/objects/2d/32dfaccd5d2397d944999a8cd08ef3f6f16c90": "cff43af665d01ea37dbdd1a942efda80",
".git/objects/2d/33f8ca3a6636c0c05c8a292ac1e9063a945d95": "741420b58035d3917d8b4d94fd170759",
".git/objects/77/0877653fb5822a8030b1a107579872c8042bde": "a5d92068bfc663a1a2b4130e85a204a8",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/4a/945d7dcef67e3960736183e7fe485113f6bdeb": "3b4f2047ad9628c1d59fc933e0685aa7",
".git/objects/4a/3c8aeaedb9a43fe840cc81e23a797822fd4014": "7d839cbb95b9bb85d90d2ffc66c33fef",
".git/objects/8d/6f787e8fd470cce98c1f5532e513bc33f6564c": "2b3c7307225ca026e5c1dfdce41a8dec",
".git/objects/15/959fefcb4708d0d5f072a2dd009ba742ce55f8": "d0d78ac935e0144b606fd111c7948463",
".git/objects/85/03c98f810fbecca2e266943c1d77ce93c7f38f": "ba951cf093fab2192f2d4c8e3bda6cd3",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/1c/5b636661af6bc0c3c8e56c11054256ae6e73e3": "b967f0f180162353def433f001422808",
".git/objects/49/6b4a163cbf863499f39f0628341debea52e8ae": "7b35fce9a8a06383725d86f279339268",
".git/objects/40/0ceb9a9930fc9b2b5eb26b2ae0f6eb462d9bfe": "da5587335ea122c879c098a1d4558954",
".git/objects/2e/5d657b528b02a54e0ae65354b3ac5d78dbde8d": "33388f2413e4fce3176e464ab751d910",
".git/objects/2b/ef8f82e7170d83985a0fdcefa4d8b5337e3341": "ab4b7146cbbe77740730a01f24c3d6c2",
".git/objects/47/23290e79e13a47cfcf9525ebad45322880f678": "226f2b89c089b9523fb0432660eb61a4",
".git/objects/78/a4e08eb1220c1e5befe592d0a12bf791421066": "242429f0ac3a7d8b004a99f7a445048c",
".git/objects/13/e0f64e55ce6807103fd4df9a414d1b5d4dda4a": "0a7146d29de0bed3eb69a1feeb428064",
".git/objects/7f/804635afc05d1c7fe6de10bc76f43986787a91": "e23d3c6f330791294ecf5f37b6fbf764",
".git/objects/7a/8265903cc8d14d6a0007c9284c00207598d9ca": "a910616fa53bd3d2e4d2e0edaac77a25",
".git/objects/14/36431360f7df9e85e0938f9b2e41db7540f0a3": "9c8823f24759c62f871f06e170ea745b",
".git/objects/22/15788429c1af632f92aa9b089c9d69eed5ee22": "d70fd095b67602f8fb5a8d6fd44c1f61",
".git/objects/22/97b264d8c8d961447a563db025a72adc0fa36a": "917bf94db0454fc04699773446d5e213",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "b59f20e8f85c0c115f5b69165998d943",
".git/logs/refs/heads/new": "8b595ee565621a02b080bcdd454711b9",
".git/logs/refs/heads/main": "3483b3249a5a730bd5ce97b387ab3fab",
".git/logs/refs/remotes/origin/code": "9a4826aada128ba927239e13700d1aaf",
".git/logs/refs/remotes/origin/master": "5a3a897ccaa7da084378e95bfaea0e81",
".git/logs/refs/remotes/origin/main": "ea6bd0d0b5e047f6a2740b90ee1579db",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/new": "77347bd7918f9cb9809b657a527e41bf",
".git/refs/heads/main": "89aa9382fbdcb2e0e1e51611e93f6978",
".git/refs/remotes/origin/code": "b7f403efb238e7c0d598772185e05932",
".git/refs/remotes/origin/master": "08792f409ccd075eec0eec4b993a0353",
".git/refs/remotes/origin/main": "89aa9382fbdcb2e0e1e51611e93f6978",
".git/index": "35bb8bc8ba21017733ed8a308a9dae0c",
".git/COMMIT_EDITMSG": "4e26f75d3cdea530d2694b0fba5431a4",
".git/FETCH_HEAD": "289832d28c5afa26a2681c718ae241f8",
"assets/AssetManifest.json": "bb1e95c1a9dd9bdbe196a867bb9f455a",
"assets/NOTICES": "d6903f7bbf2906ffd3e5bfcccc3bb673",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb3d13940b03ddb90fb11c521383a266",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "3dd2808d1813c38522ab37da82ad2614",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "2118ebfea9627cfe5919ecbd9d329bfe",
"assets/fonts/MaterialIcons-Regular.otf": "80a1d83cd27c79e1cf57f2ebdd818148",
"assets/assets/images/useBalance.png": "0dcd8834a15a8ff9500a511893a0b01c",
"assets/assets/images/afterUse.png": "e693a41e5e391fee25ef012aec5f0720",
"assets/assets/images/showLedger.gif": "2c2d22f317c3bdb11c399157e1f9df29",
"assets/assets/images/worriedMenBG.png": "b383aa640c79491fa6e30e6cd166ddd8",
"assets/assets/images/home.png": "d91560894edbd6c8790a8e72a823e4a9",
"assets/assets/images/worriedMen.png": "0ad8cdfbcb0bd2a0c9634586e7306b6f",
"assets/assets/images/use.png": "f230e11c2d203419e879d41ae0bbdbbd",
"assets/assets/images/customer.png": "53dbd4e472cd61875ba7e18f15274953",
"assets/assets/images/favorite.png": "268b8b0bb48edc7968cff2a9e58f9084",
"assets/assets/images/showLedgerOrigin.gif": "a204d4baa2d059771d76c03af47aea6b",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

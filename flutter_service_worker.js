'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c03fe4ded1a6c31d0306c22cdb84d93a",
"assets/AssetManifest.bin.json": "365c503859d3774c780ae1f0af5ab9ed",
"assets/AssetManifest.json": "dfd9db7816383ab967f7090776958514",
"assets/assets/apple.png": "467e26c4d4f7bcee484e022b43050297",
"assets/assets/aquarium_background.jpg": "1b6ac0612b14a24a61d926d8f00b554e",
"assets/assets/aquarium_background2.jpg": "c4b1d12b239c377ef77ed17028b7915f",
"assets/assets/aquarium_background3.jpg": "87cf8b0181bc179f9e74502082655105",
"assets/assets/audios/CallOfSilence.mp3": "a1f0607c34ae10506bfd7d405e696cf6",
"assets/assets/audios/Everytime-We-Touch.mp3": "4df0c004851dd6a57bba44f422c0fe15",
"assets/assets/audios/Fantaisie-Impromptu.mp3": "477f4124efded8fc9338d59fa2d86dbc",
"assets/assets/audios/Miss-you.mp3": "d6b5c440b5563aab24a1a2ac1c772134",
"assets/assets/audios/MoonlightSonata3rdMvt.mp3": "8b19fa343d3b8278a86f6204160fe79d",
"assets/assets/audios/Revolutionary-Etude.mp3": "8bc28013e7d668ecd458dbb69b0b0ee8",
"assets/assets/audios/Wonderful-tonight.mp3": "dd7b6034699e95ff67ed9ba3c45c014e",
"assets/assets/barcode-lt.png": "a79b1443f8cbd688244ebc0f755eb7f0",
"assets/assets/barcode-scan-lt.png": "1cc355d930a53a6f1fe0d4c4ff147342",
"assets/assets/barcode-scan.png": "1cf9ec5d3877b2dbad27c03ca9ec478e",
"assets/assets/barcode.png": "e4619daea313532be2844af71ad38ea1",
"assets/assets/barcode_anim1.json": "dd05318a093eb08742bcb7ec8385b39e",
"assets/assets/barcode_anim2.json": "b681ce2513e4669825198c5aed39d791",
"assets/assets/bbc-news.png": "d321dc6f34f6d94a877cb89c1fa59ccd",
"assets/assets/beans.png": "6fef1b1ced36782322a8c280e17947ae",
"assets/assets/bibimbap.png": "00957f2d5d5736c8fe1afcd2c742c756",
"assets/assets/burger.png": "aeb64a1d60e0f7a93f6cffecac553db7",
"assets/assets/burgerr.png": "8c9aa7cc9cd570205781d66470e33a29",
"assets/assets/chicken.png": "f51850e1015f30114e534929da9fce0b",
"assets/assets/countries.json": "55d13e49d7177f6c2fcc5f681123a76a",
"assets/assets/dash.png": "cd612c09936f7a6f5674fcdd65ff6e6b",
"assets/assets/diet.png": "7cbf6d7704484301533a703be36356fd",
"assets/assets/donut.png": "19fac450af106b5d24f68f4dd9ced3e1",
"assets/assets/fish.png": "07cbb13eb0c74c059aec11e656f59550",
"assets/assets/fish10.png": "38b883f2aedbf69f18614be577c50e21",
"assets/assets/fish2.png": "dc16eb8994743185ebc328f70dd31b21",
"assets/assets/fish3.png": "24cd3e4e3b666be676c9d91c0ee9243f",
"assets/assets/fish4.png": "abccae7201981eaf1cfd83dfc3a45e01",
"assets/assets/fish5.png": "f334a16c5454152ac8b7fcd7b2385089",
"assets/assets/fish6.png": "aac035c05ca608595aa6a73aa761ee7a",
"assets/assets/fish7.png": "c6affdd7c1d54da6a45bcf67db39d497",
"assets/assets/fish8.png": "90a6c1b7b176107e369dee5e63791d92",
"assets/assets/fish9.png": "de173ee96d77803ddc0d6418c561e620",
"assets/assets/fries.png": "4b35dec44587282ef4a0f7a97e4a0eda",
"assets/assets/google.jpg": "29bf4f9c31b5693131908d512eedb185",
"assets/assets/hacker-news.png": "cf4375f96e564d0434ac844107e94fce",
"assets/assets/image_not_found.png": "abdd26b8f569d74ef0dbd36ce9b10768",
"assets/assets/instagram.png": "b407fa101800e44839743a60e6078ed3",
"assets/assets/lemon.png": "ce0dc7e76dedcbd18c81ecd01a1104fc",
"assets/assets/lettuce.png": "1c2341443ba79bf8d7415cb4c1f4e4b0",
"assets/assets/manga1.jpg": "ca45b7491d65fed97fd5e737c1a8a17d",
"assets/assets/manga10.jpg": "20e3ff97195493cf6982ebdcfc4fc715",
"assets/assets/manga11.jpg": "395853729060fc33986332d58bc24e6f",
"assets/assets/manga12.jpg": "ed774f310701ccebe80102f0e5f7e519",
"assets/assets/manga13.jpeg": "bc44555051f13c11978dd30c99a4512f",
"assets/assets/manga14.jpeg": "7c44a1d3b278c9df7801956cd76fad62",
"assets/assets/manga2.jpg": "266ac4ccd847ca33f6da4877f6a36241",
"assets/assets/manga3.jpg": "83948c40a68551fa641a120ff9a06834",
"assets/assets/manga4.jpg": "c7ace8178768bbd424300c7add0340a5",
"assets/assets/manga5.jpg": "70d084761448a47dc0ddf0140dc76d31",
"assets/assets/manga6.png": "ec40ad449bb57ebbc85c2deefc168cd0",
"assets/assets/manga7.jpg": "f301e02c92b55a052361c56ee5c44506",
"assets/assets/manga8.jpg": "863f789fcde888d5e328d98b4da0a6ed",
"assets/assets/manga9.jpg": "e614b64bcad81b085606e4370f96b43d",
"assets/assets/medium.png": "0a3d6c7d3e37a5261887e8d08a103c28",
"assets/assets/microsoft.jpg": "758464e8cfcabdacd3a79667fd99034e",
"assets/assets/nature.jpg": "6df27eef3499abfc4bc6a58b1f3eef4b",
"assets/assets/nature2.jpg": "318f41ddf804d09a6e3abde8ed0c2316",
"assets/assets/nature3.jpg": "3715bf2bc49dde2d5634e5ae38f2a0f1",
"assets/assets/nature4.jpg": "cc3d0af58d48f369fa98cf41628053cb",
"assets/assets/nature5.jpg": "4e4033a70767c1dad15eedea99d5f60a",
"assets/assets/nature6.jpg": "338e380d5076e7fd2cbf26576e147493",
"assets/assets/nature7.jpg": "adc302d17fc4197eec255189a7ff8651",
"assets/assets/nature8.jpg": "19638a654a4374259c9dc70645ea8b90",
"assets/assets/onion-rings.png": "2c0e2b652446e40c5202b0fbfacc0c73",
"assets/assets/pizza.png": "efbead742fab4ff35c1015ae1123bf4e",
"assets/assets/pizzaa.png": "1523e3864d85a10b8cc10527bd1ab69d",
"assets/assets/plate.png": "208c7e7eee9a82d3a74bd5c0c5561041",
"assets/assets/ramen.png": "f5d4b84c15def3d8a5c769b582fdf13a",
"assets/assets/salad.png": "d1678bcc876fc1441c2a37a9dc496525",
"assets/assets/saladd.png": "24506f15a7a2dba32754725096ec6be0",
"assets/assets/searching.json": "7bdfda02f59a90c4f8a9b5fa25f88c74",
"assets/assets/soft-drink.png": "958ba4f8af7b934061c1590ac5c7755d",
"assets/assets/spaghetti.png": "0dca48a3dcb08b2cc4d425d6e2b40da3",
"assets/assets/spaghetti_bolo.jpg": "dbf9ed20093e69dcc015054eb5877f80",
"assets/assets/sushi.png": "f6c1645daf268838548465f7b8d29fe1",
"assets/assets/taco.png": "673a32d97b0586c2d25fa7bda7f71747",
"assets/assets/tesla.jpg": "e1a4d72fd805d5f8495cd2266d3fea6d",
"assets/assets/veggie.png": "17cf2d185fbcaadba9b448609e3bf6ec",
"assets/assets/whopper.png": "8c9aa7cc9cd570205781d66470e33a29",
"assets/assets/youtube.png": "69a0bb58a1cb84978c752450bdd93469",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "f69a228a269660fda5dff9df8cb8bbe8",
"assets/NOTICES": "bc1f9ec095247394389a301298d15f84",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "df6f9a35929fd5960f0baa0c5c5f981d",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "1ecd8f84f83cd1dab5dd7c400111ac67",
"/": "1ecd8f84f83cd1dab5dd7c400111ac67",
"main.dart.js": "755a7b1268bd7c9b2417896f122a0080",
"manifest.json": "9a1529b7ed1c2d6c467c7d5ea517fea3",
"version.json": "a61a03ca82a7a5ee7df7bd24fa462921"};
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

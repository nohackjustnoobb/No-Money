'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "07674e85f14b4923cef6e34754e051b5",
"splash/img/light-2x.png": "f00a6ae96eb7c51342be1183651ef9cb",
"splash/img/dark-4x.png": "d3cdde5914ebfc077613885d20e15211",
"splash/img/light-3x.png": "1609878a131e8a6f215e3b7cc0ac803c",
"splash/img/dark-3x.png": "1609878a131e8a6f215e3b7cc0ac803c",
"splash/img/light-4x.png": "d3cdde5914ebfc077613885d20e15211",
"splash/img/dark-2x.png": "f00a6ae96eb7c51342be1183651ef9cb",
"splash/img/dark-1x.png": "2abf1fcdf015e4422e162ed6c7fa58b7",
"splash/img/light-1x.png": "2abf1fcdf015e4422e162ed6c7fa58b7",
"splash/splash.js": "c6a271349a0cd249bdb6d3c4d12f5dcf",
"splash/style.css": "178d1de5c77f757ca71c9415d49e6b04",
"favicon.ico": "898e4eb6d0a634e5063ec2850400bda5",
"index.html": "8fb27b19b9615a1feb145533181ae7af",
"/": "8fb27b19b9615a1feb145533181ae7af",
"main.dart.js": "dd5428deea45db5cbc9a592657eb67c5",
"flutter.js": "0816e65a103ba8ba51b174eeeeb2cb67",
"icons/apple-icon.png": "94d491eb11085f381688fd74a4b51c40",
"icons/android-icon-192x192.png": "7636b8a0d551472f348eff575190faa6",
"icons/favicon-96x96.png": "b7289e647df3c047b32f757924222c94",
"manifest.json": "584252a6b64178eee444393ff123e9b4",
".git/config": "ca7a0d173eb5f62d65f5cd64a6eff975",
".git/objects/0d/0df08f7c3e147a8ae36017cf81a96e35b73717": "106e868f28a72727fb6fb0fa71123633",
".git/objects/50/edde3f7a2cf1f79ad33e558bb73d816072e42c": "e212ec0dd9f3ccd0de5aa09ecffe623d",
".git/objects/32/efab146f9e2246117b2e33d8b16b273b4534fa": "aca9a56eceb2eaaa880921ed0c6a76ab",
".git/objects/56/92886fa172b8a922f868ca9198cbae940dccc8": "7f4bad26958195a526ea17690877b602",
".git/objects/3d/429fa19b9a245808bf6235829066699d979388": "943da395cae89a5d6bf2498526c2cfa5",
".git/objects/5a/101363b658707c343770a900586c71fd46d453": "69f9f881e639b5106df833afff5df2aa",
".git/objects/02/0f5e56a927a04113ecb38d06238b0c2998ee52": "b74ec5f14b7d6eaa207cddb2b632edf0",
".git/objects/b5/522c4d299ba02e54044cce355d4b941a8804e1": "f5ff57db3922ed2a01e43779ea4b0da0",
".git/objects/bc/919f35356827f1247efebb99ba5c88f0fc93c6": "b89c4255710433628daadc3ba698a60b",
".git/objects/ae/7887aba2578d017915d34e65875fcb66cadb25": "eecb9756dd0699fdc6840d8f042883ed",
".git/objects/e5/951dfb943474a56e611d9923405cd06c2dd28d": "c6fa51103d8db5478e1a43a661f6c68d",
".git/objects/e2/5b400deac3736918447fb92963825d7fc73b77": "86522f6449fa1c56f82f948a1c47f373",
".git/objects/e4/4024e4d45c5fe8457bdbfb20b18ae3d0001605": "c4d0f33855fc052cc63da1181a047dfd",
".git/objects/fe/76b9b6652182db66b320eb26b3d2931fb77235": "29150685495cb94de37edf052f3d0a74",
".git/objects/4e/89617a3696bd10c155ec378f4a65a9f89e9e3a": "d8056e20bae90d092b619c895129e982",
".git/objects/18/47e15bad62677758d692f3ddbfada7ac0ea641": "4aef87635e6914cb0534c67b9570bebd",
".git/objects/7d/f00c6e75c2c0d0f9cd61c09da1ffb0dc22b963": "978f6fa8dec2cc93a2f674c6d4e7ab30",
".git/objects/7c/4a625f31d63d0d2dee695110557e18bddd008a": "481241cb4b6a916c85433f2aceae1fd9",
".git/objects/7c/679f6d37fa4f6a55442592ae531d2e55e4053c": "30d7c6cfe3db7672b0e0e803ade06390",
".git/objects/89/8c454fb6fe50c7f05cdc2db89df05001d7789a": "f59660eb83869db55bb29a29b3834420",
".git/objects/45/51084ac0337fcfcea3ccec3f9637982bc6f508": "dce8087708b23e3d8ab2a657fffb893d",
".git/objects/8a/3445e6c2663af8730d1925d07a1cccc49b7bbe": "5df19d2a03f261a85f22ee3a7e29e4d9",
".git/objects/10/f66984dae8b6fdf11ac65eda74173046cf08f1": "cc8279975e7003b4ac3710e9207a0678",
".git/objects/19/6ee07a2d6841ccbf2fd2d7a0e5750f081348fc": "d9558c6c59755105e0ed2fdcf8eea902",
".git/objects/07/ce8aae6e15b16c2a24ab1b5b7a0aadf5911334": "a6a03569a4b00513e0ad6c3f902c6194",
".git/objects/5d/a94800b0127267a6870e6ee67221d71202812e": "0430953f1b35e58f713c3d356d383d62",
".git/objects/30/cb62bd2847e8d4c663ea17d58af0c2b463f6ee": "5a38392c551ba0fe7b06a424ca325280",
".git/objects/5e/8280ccd0c3ee225654de10dc6b99fad5530cae": "db81e9edbc2f76b2e6b0a55ee5533276",
".git/objects/97/5f981add8f6ce3fba396d79c1f827afe8bf563": "45e5ee9f586ba7bf1921dcbbfb4ee27c",
".git/objects/ba/873595714be0aed5b3f40c3f409125d58b741e": "090eab633a2fc6144387ae5913e6fe15",
".git/objects/dd/5edb1a7e46855a8138b7028913a7aed7e07a26": "15779bbfbf84adb4b688dcd6964caa7f",
".git/objects/dc/bfb0cd77a83fff30226baabe2ed883def17f10": "d1a4c21872449b10adc45473f78988cf",
".git/objects/db/05b329a2434e6717c809a12aa3d411bc8693aa": "0241822ba20b91dafd96d4769e7b695d",
".git/objects/de/b2f9963aa9e6ab42cddaa1fcf310504ca51eae": "a6c09005a2368d6d3518cff423640e43",
".git/objects/de/28db843d7df6ed23b8a7526f6b6b4a83425fe7": "797e4f7b3d8dced098c51679ff33e848",
".git/objects/a1/3837a12450aceaa5c8e807c32e781831d67a8f": "bfe4910ea01eb3d69e9520c3b42a0adf",
".git/objects/c3/ab80c589d4465c3abf05d2493d643b4e484316": "3e52f6c8c63cc285160d349269fdf87b",
".git/objects/c3/e9627f99cd7153b66be6a774d006bf79d2663a": "2f734a617c36fd037b296bee07a6495a",
".git/objects/cd/22076013ce8b84475eae9bb4cd6c60b5460fbe": "81c620e2d6cbe5638d6c90ee25886389",
".git/objects/e9/e575d0b36ebd696294496017834c26b62e1505": "8eca52e53d59927cc7c00a13888ea67b",
".git/objects/f8/d02b63f67dd0d08241b397f4e4b4dc31f9ba52": "35c5313a4baacd1e0a8765ec64f06e5b",
".git/objects/79/ba7ea0836b93b3f178067bcd0a0945dbc26b3f": "f3e31aec622d6cf63f619aa3a6023103",
".git/objects/2d/cf3542c874e33cd8ab86ceb6f0ec444228aa78": "66baad0ae5d874f09b6eee790095bc65",
".git/objects/41/d7f390b5283a374219ce5024b018f2393e782d": "4c4ac19872dc34a7bec69a3aad045322",
".git/objects/24/b1f14dd348b07c9b8373758bde9ac14d16fd92": "dbf45d6c044044561758a334420e9569",
".git/objects/24/b2b95548d144fe1879a3b5c9c2cf93157d4f7a": "a9b465a1c9e223ef689ba44174dc9603",
".git/objects/23/d6a249c6cca7541102874a4aca0b5677023ba6": "32b8136b5643c38508f0a3ac24df7422",
".git/objects/76/8651b2e249c2517c7b37bdbeea0a5d8bfbb707": "495b1c4fefa633f6afe4dc5840ebe18f",
".git/objects/13/2dab74263317a81c7a2e13de6a2585c8b88969": "340abece48542272bf55ccbcf4d9216c",
".git/objects/7a/c08c8c7510096074e9736b3b2bbdf2f8c6be0c": "7ba4299bc76eb8eeaa5d7a682eafc430",
".git/objects/7a/ddd315ff6155e9ab5dd2ff250e644cd1f7457b": "e751bb0a3dd881f6167b1a730ffb38b8",
".git/HEAD": "41cb66798200aed5290c3d46fca32d57",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "b8fe6c9aedf09004dccfafa0fded612b",
".git/logs/refs/heads/webpage": "b8fe6c9aedf09004dccfafa0fded612b",
".git/logs/refs/remotes/origin/webpage": "25aa71e0ef4067f1c22e97720eb66113",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "ea587b0fae70333bce92257152996e70",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/webpage": "105aad0c82be945b8754e0b4c2181a2f",
".git/refs/remotes/origin/webpage": "105aad0c82be945b8754e0b4c2181a2f",
".git/index": "323843fe26ab3f0c40dc073a4aa7a820",
".git/COMMIT_EDITMSG": "35f672d1fb01b542f667952c9dbb26fe",
"assets/AssetManifest.json": "b627a4b535d27fd8d6fab5babcdf1697",
"assets/NOTICES": "f3a461d8d122fbc1b5e28fe91aff63be",
"assets/FontManifest.json": "1b1e7812d9eb9f666db8444d7dde1b20",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "b62641afc9ab487008e996a5c5865e56",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/flex_color_picker/assets/opacity.png": "49c4f3bcb1b25364bb4c255edcaaf5b2",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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

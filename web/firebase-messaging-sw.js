// Use the compat (UMD) builds so importScripts works in the service worker
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: 'AIzaSyC2S3YVYOw4qkqd8nw4RL-H3lDTgApYWO8',
    appId: '1:747220995902:web:26eeecd27265364298e66f',
    messagingSenderId: '747220995902',
    projectId: 'medireach-53050',
    authDomain: 'medireach-53050.firebaseapp.com',
    storageBucket: 'medireach-53050.firebasestorage.app',
    measurementId: 'G-WP72LSXS62',
});

const messaging = firebase.messaging();

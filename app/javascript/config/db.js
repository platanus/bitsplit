import firebase from 'firebase/app';
import 'firebase/database';

const firebaseConfig = {
  apiKey: 'AIzaSyAkdRGfIWErUzD6XG6nVUHKWxihOdW01zg',
  authDomain: 'platanus-bitsplit.firebaseapp.com',
  databaseURL: 'https://platanus-bitsplit.firebaseio.com',
  projectId: 'platanus-bitsplit',
  storageBucket: 'platanus-bitsplit.appspot.com',
  messagingSenderId: '716332483102',
  appId: '1:716332483102:web:2f2a368481f968b31de40f',
};
// Get a RTDB instance
export const db = firebase.initializeApp(firebaseConfig).database();

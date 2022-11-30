
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import {getAuth,signInWithEmailAndPassword} from "firebase/auth"

import "firebase/firestore"
const firebaseConfig = {
  apiKey: "AIzaSyAI8m8vABNvewFTXcozIXYtP4ak1E7vKDE",
  authDomain: "goubi-360003.firebaseapp.com",
  databaseURL: "https://goubi-360003-default-rtdb.firebaseio.com",
  projectId: "goubi-360003",
  storageBucket: "goubi-360003.appspot.com",
  messagingSenderId: "196742219163",
  appId: "1:196742219163:web:d3b67cfecf0b6e4cc00d3e",
  measurementId: "G-6JD26YNK0V"
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth =  getAuth(app);

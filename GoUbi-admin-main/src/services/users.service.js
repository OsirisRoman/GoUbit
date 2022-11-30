import { db } from "../firebase";

import {
  collection,
  getDocs,
  getDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  doc,
} from "firebase/firestore";

const userCollectionRef = collection(db, "users");
class UserDataService {
  addBooks = (newBook) => {
    return addDoc(userCollectionRef, newBook);
  };

  updateBook = (id, updatedBook) => {
    const bookDoc = doc(db, "users", id);
    return updateDoc(bookDoc, updatedBook);
  };

  deleteBook = (id) => {
    const bookDoc = doc(db, "users", id);
    return deleteDoc(bookDoc);
  };

  getAllUser = () => {
    return getDocs(userCollectionRef);
  };

  getUser = (id) => {
    const userDoc = doc(db, "users", id);
    return getDoc(userDoc);
  };
}

export default new UserDataService();
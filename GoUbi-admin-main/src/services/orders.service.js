import { db } from "../firebase";

import {
  collection,
  getDocs,
  getDoc,
  doc,
} from "firebase/firestore";

const userCollectionRef = collection(db, "orders");
class OrderDataService {

  getAllOrders = () => {
    return getDocs(userCollectionRef);
  };

  getOrder = (id) => {
    const userDoc = doc(db, "orders", id);
    return getDoc(userDoc);
  };
}

export default new OrderDataService();
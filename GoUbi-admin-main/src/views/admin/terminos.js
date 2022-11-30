import React , {useEffect}from 'react'
import { useNavigate } from "react-router-dom";

import {
    CCard,
    CCardBody,
    CCardFooter,
    CCardHeader,
  } from '@coreui/react'
  import Cookies from 'js-cookie'
const Dashboard = () => {
  const navigate = useNavigate();
  useEffect(() => {
    let cookie = Cookies.get('access-token')
    if(!cookie){
      navigate("/login")
    }
  }, []);


  return (
    <>
      <CCard className="mb-4">
        <CCardHeader>
        <strong style={{ fontSize: "25px" }} >Termino y condiciones</strong>
       
        </CCardHeader>
  
        <CCardBody>
        GoUbi es la manera más fácil de pedir y recibir lo que tú quieras en tú ciudad. Con GoUbi podrás pedir productos o servicios en tus cercanías, en pocos minutos lo tendrás en la puerta de tu domicilio. Cuidamos tus momentos, apreciamos tu tiempo, respetamos tus deseos.
        </CCardBody>
        <CCardFooter>
          
        </CCardFooter>
      </CCard>

    </>
  )
}

export default Dashboard

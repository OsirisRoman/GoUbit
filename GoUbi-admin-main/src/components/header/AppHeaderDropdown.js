import React from 'react'
import { useNavigate } from "react-router-dom";
import {
  CAvatar,
  CBadge,
  CDropdown,
  CDropdownDivider,
  CDropdownHeader,
  CDropdownItem,
  CDropdownMenu,
  CDropdownToggle,
  CHeaderText
} from '@coreui/react'
import {
  cilLockLocked,
  cilSettings,
  cilUser,
} from '@coreui/icons'
import CIcon from '@coreui/icons-react'
import { useNavigate } from "react-router-dom";
import avatar8 from './../../assets/images/avatars/8.jpg'
import Cookies from 'js-cookie'

const AppHeaderDropdown = () => {
  const navigate = useNavigate();
  const logOut = ()=>{
    console.log("chau")
    Cookies.remove('access-token')
    navigate("/login")
  }

  return (
    <CDropdown variant="nav-item">
      <CDropdownToggle placement="bottom-end" className="py-0" caret={false}>
        <CHeaderText className='p-2'>
          Administrador GoUbi
          </CHeaderText>
          <CIcon icon={cilUser} className="me-2"/>
      </CDropdownToggle>
      <CDropdownMenu className="pt-0" placement="bottom-end">

        <CDropdownHeader className="bg-light fw-semibold py-2">Menu</CDropdownHeader>
    
        <CDropdownItem href="/parametros">
          <CIcon icon={cilSettings} className="me-2" />
          Configuraciones
        </CDropdownItem>
        <CDropdownDivider />
        <CDropdownItem onClick={()=>logOut()} >
          <CIcon icon={cilLockLocked} className="me-2"/>
          Cerrar Sesion
        </CDropdownItem>
      </CDropdownMenu>
    </CDropdown>
  )
}

export default AppHeaderDropdown

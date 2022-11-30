import { React,useEffect }  from 'react'
import { useNavigate } from "react-router-dom";
import {
  CButton,
  CCard,
  CCardBody,
  CCardGroup,
  CCol,
  CContainer,
  CForm,
  CFormInput,
  CInputGroup,
  CInputGroupText,
  CRow,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilLockLocked, cilUser } from '@coreui/icons'
import logo from 'src/assets/logo.png'
// import {app} from '../../admin/f'
import swal from 'sweetalert';



const Login = (props) => {

  //const [isRegistrando, setIsRegistrando] = React.useState(false);

  const navigate = useNavigate();
  useEffect(() => {
    // const user= localStorage.getItem('user');
    // console.log('este es el user',user);
    // if(user){
    //   console.log('en el iffffffffffffff',user);
    //   navigate("/solicitudes")

    // }
  }, []);


  const workin = () =>{
    navigate("/solicitudes")
  }

  const alertError = () => {

    swal({
      title: "Autentificacion Erronea",
      text: "Usuario o Contraseña Incorrecta",
      icon : "error"
    })
  }

    const iniciarSesion = (correo, password) => {
      app
        .auth()
        .signInWithEmailAndPassword(correo, password)
        .then((usuarioFirebase)  => {
          console.log("sesión iniciada con:", usuarioFirebase.user);
          localStorage.setItem('user',usuarioFirebase.user);
          workin();

        }).catch((err) => {
          alertError()
          console.log("Error inicio de Session");
        });




    };

    const handleSubmit = (e) => {
    //   e.preventDefault();
    //   const correo = e.target.emailId.value;
    //   const password = e.target.passwordId.value;
    //   iniciarSesion(correo, password)
  }
  return (
    <div className="bg-light min-vh-100 d-flex flex-row align-items-center">
      <CContainer>
        <CRow className="justify-content-center">
          <CCol md={5}>
            <CCardGroup>
              <CCard className="p-4">
                <CCardBody>
                  <div style={{display:"flex",justifyContent: "center",marginBottom:"2em" }}>
                    <img src={logo} alt="this is car image" width={100} height={100}/>
                  </div>

                  <CForm onSubmit={handleSubmit}>

                    <CInputGroup className="mb-3">
                      <CInputGroupText>
                        <CIcon icon={cilUser} />
                      </CInputGroupText>
                      <CFormInput placeholder="Email" id="emailId" required  />
                    </CInputGroup>
                    <CInputGroup className="mb-4">
                      <CInputGroupText>
                        <CIcon icon={cilLockLocked} />
                      </CInputGroupText>
                      <CFormInput
                        type="password"
                        placeholder="Password"
                        id="passwordId"
                        autoComplete="current-password"
                        required
                      />
                    </CInputGroup>
                    <CRow>
                    <CButton  type="submit" color="primary" className="px-4">
                      {" "}
                          Iniciar sesion
                      </CButton>

                    </CRow>
                    <CRow>
                    <CButton color="link" className="px-0" >
                    Registrate
                    </CButton>
                    <CButton color="link">
                         Recuperar Contrasena
                      </CButton>
                    </CRow>
                  </CForm>
                </CCardBody>
              </CCard>

            </CCardGroup>
          </CCol>
        </CRow>
      </CContainer>
    </div>
  )
}

export default Login

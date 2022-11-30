import React, { useEffect, Suspense } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'
import { CContainer, CSpinner } from '@coreui/react'

// routes config
import routes from '../routes'


// // Pages
// const Login = React.lazy(() => import('../views/pages/login/Login'))
// const Register = React.lazy(() => import('../views/pages/register/Register'))
// const Solicitudes = React.lazy(() => import('../views/admin/solicitudes'))
// const Page500 = React.lazy(() => import('../views/pages/page500/Page500'))

const AppContent = () => {

  const [usuario, setUsuario] = React.useState(null);
  useEffect(() => {
    // app.auth().onAuthStateChanged((usuarioFirebase) => {
    //   console.log("ya tienes sesión iniciada con:", usuarioFirebase);
    //   setUsuario(usuarioFirebase);
    // });
  }, []);


  return (
    <CContainer lg>
      <Suspense fallback={<CSpinner color="primary" />}>


        <Routes>
          {routes.map((route, idx) => {
            return (
              route.element && (
                <Route
                  key={idx}
                  path={route.path}
                  exact={route.exact}
                  name={route.name}
                  element={<route.element />}
                />
              )
            )
          })}
          <Route path="/" element={<Navigate to="login" replace />} />
        </Routes>
      </Suspense>
    </CContainer>
  )
}

export default React.memo(AppContent)

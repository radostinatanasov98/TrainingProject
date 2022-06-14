window.NavBar = createReactClass({
    render: function () {
        const isDoctor = this.props.role == 'doctor'
        const isPatient = this.props.role == 'patient'

        function logout(e) {
            e.preventDefault()

            axios.defaults.withCredentials = true;

            try {
                axios({
                method: 'DELETE', 
                url: 'http://localhost:3000/api/sign_out',
                mode: 'cors',
                }).then((res) => {
                  sessionStorage.removeItem('exp')
                  sessionStorage.removeItem('refresh_token')
                  window.location = "http://localhost:3001/users/log_in"
                })
              } catch (error) {
                console.error(error)
              }
        }

        return (
            <div className="navContainer">
                <nav className="navWrapper">
                    <ul className="navigation">
                        {
                            isPatient &&
                            <React.Fragment>
                                <li className="navLi"><a className="navLink" href={`/profile?id=${sessionStorage.getItem('user_id')}`} >EXAMINATIONS</a></li>
                            </React.Fragment>
                        }
                        { isDoctor && 
                            <React.Fragment>
                                <li className="navLi"><a className="navLink" href="/patients">PATIENTS</a></li>
                            </React.Fragment>
                        }
                    </ul>
                    <form className="sign-out-form">
                        <button className="sign-out-btn" onClick={logout}>Sign Out</button>
                    </form>
                </nav>
            </div>
        )
    }
})
window.Login = createReactClass({
  render: function () {
    login = (e) => {
      e.preventDefault()

      body = getBody()

      axios.defaults.withCredentials = true;

      res = tryLogin().catch((error => {
        displayErrorMessage()
        return
      }))

      res.then((res) => {
        handleSession(res)
      })
    }

    handleSession = (res) => {
      let exp = new Date().getTime() / 1000;
      const user_id = res.data.user_id
      exp += res.data.expires_in
      sessionStorage.setItem('exp', exp)
      sessionStorage.setItem('user_id', user_id)
      sessionStorage.setItem('refresh_token', res.data.refresh_token)
      window.location = "http://localhost:3001/profile?id=" + user_id
    }

    tryLogin = () => {
      return axios({
        method: 'POST',
        url: 'http://localhost:3000/oauth/token',
        mode: 'cors',
        headers: { 'Content-Type': 'application/json' },
        data: JSON.stringify(body),
      })
    }

    getBody = () => {
      return {
        'grant_type': 'password',
        'email': this.email.value,
        'password': this.password.value,
        'client_id': this.props.client_id,
        'client_secret': this.props.client_secret
      }
    }

    displayErrorMessage = () => {
      document.getElementById('error_message').style.display = 'block'
    }

    return (
      <div className="login-page">
        <div className="form">
          <div className="login">
            <div className="login-header">
              <h3>Welcome!</h3>
              <h4 id="error_message">Invalid username or password.</h4>
            </div>
          </div>
          <form className="login-form">
            <input type="text" name="email" placeholder="Email" ref={email => this.email = email} />
            <input type="password" name="password" placeholder="Password" ref={password => this.password = password} />
            <input type='hidden' name="authenticity_token" value={this.props.authenticityToken} />
            <button type="submit" onClick={login}>login</button>
          </form>
        </div>
      </div>
    )
  }
})
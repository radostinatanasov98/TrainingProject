set_refresh()

setInterval(token_check, 60000)

function token_check() {
    if (sessionStorage.getItem('exp') == undefined) {
        return
    }

    let date = new Date().getTime() / 1000
    let exp = sessionStorage.getItem('exp')

    if (exp - date <= 60) {
        try {
            data = {
                'grant_type': 'refresh_token',
                'refresh_token': sessionStorage.getItem('refresh_token'),
                'client_id': window.info.uid,
                'client_secret': window.info.scrt
            }

            fetch('http://localhost:3000/oauth/token', {
            method: 'POST', 
            mode: 'cors',
            credentials: 'include',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
            })
            .then(response => response.json())
            .then((res) => {
              console.log(res)
              let exp = new Date().getTime() / 1000;
              exp += res.expires_in
              sessionStorage.setItem('exp', exp)
              sessionStorage.setItem('refresh_token', res.refresh_token)
            })
          } catch (error) {
            console.error(error)
          }
    }
}

function set_refresh() {
  sessionStorage.setItem('refresh_token', window.info.rt)
}
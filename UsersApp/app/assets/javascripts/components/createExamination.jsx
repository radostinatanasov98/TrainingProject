class CreateExamination extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      len: 0,
      drugs_forms: [0]
    };
  }

  AddDrugForm() {
    this.setState({ drugs_forms: [...this.state.drugs_forms, this.state.len += 1] });
    console.log(this.state.drugs_forms)
  }

  RemoveDrugForm() {
    this.state.drugs_forms.pop()
    this.setState({ drugs_forms: [...this.state.drugs_forms] });
    this.setState({ len: this.state.len -= 1 })
    console.log(this.state.drugs_forms)
  }

  componentDidMount() { }

  submit(e, bearerToken, authenticityToken) {
    e.preventDefault()

    let examination = this.createBody()

    if (!this.validateInput(examination)) {
      return 'Invalid input.'
    }

    axios.defaults.headers.common['X-CSRF-TOKEN'] = authenticityToken


      req = this.tryCreateExamination(bearerToken, examination).then((res) => {
        if (res.status != 200) {
          window.location.reload()
        }
        else {
          window.location = "http://localhost:3001/patients"
        }

      })
  }

  tryCreateExamination(bearerToken, examination) {
    return axios({
      method: 'POST',
      url: 'http://localhost:3000/api/examinations/create',
      headers: { 'Authorization': `Bearer ${bearerToken}`, 'Content-Type': 'application/json' },
      data: JSON.stringify(examination),
    })
  }

  createBody() {
    let examination = {
      user_id: Number.parseInt(new URLSearchParams(window.location.search).get('id')),
      weight_kg: Number.parseFloat(document.getElementById('weight_kg').value),
      height_cm: Number.parseFloat(document.getElementById('height_cm').value),
      anamnesis: document.getElementById('anamnesis').value,
      perscription: {
        description: document.getElementById('description').value,
        drugs: []
      }
    }

    const drugsForms = document.getElementsByName('drug')

    for (let i = 0; i < drugsForms.length; i++) {
      const drugNode = drugsForms[i].childNodes

      const drug = {
        drug_id: Number.parseInt(drugNode[1].value),
        usage_description: drugNode[0].value
      }

      examination.perscription.drugs.push(drug)
    }

    return examination
  }

  validateInput(data) {
    if (data.weight_kg == NaN || data.weight_kg == '' || data.height_cm == NaN || data.height_cm == '' ||
      data.anamnesis == NaN || data.anamnesis == '' || data.perscription.description == NaN || data.perscription.description == '') {
      this.displayErrorMessage()
      return false
    }

    for (let i = 0; i < data.perscription.drugs.length; i++) {
      const drug = data.perscription.drugs[i]
      if (drug.drug_id == NaN || drug.drug_id == '' || drug.usage_description == NaN || drug.usage_description == '') {
        this.displayErrorMessage()
        return false
      }
    }

    return true
  }

  displayErrorMessage() {
    document.getElementById('error_message').style.display = 'block'
  }

  render() {
    return (
      <div className="login-page ce">
        <div className="form">
          <div className="login">
            <div className="login-header">
              <h3>Creating an examination for: {this.props.user.first_name} {this.props.user.last_name}, {this.props.user.email}</h3>
            </div>
          </div>
          <form className="login-form">
            <h3 id="error_message">Please check if all of the data is correct, and try again.</h3>
            <h3>EXAMINATION</h3>
            <input type="number" id="weight_kg" name="weight_kg" placeholder="Weight in kg" />
            <input type="number" id="height_cm" name="height_cm" placeholder="Height in cm" />
            <input type="text" id="anamnesis" name="anamnesis" placeholder="Anamnesis" />
            <h3>PERSCRIPTION</h3>
            <input type="text" id="description" name="description" placeholder="Description" />
            <div id="drugsContainer">
              <h3>DRUGS</h3>
              {this.state.drugs_forms.map((i) => <DrugFormTemplate drugs={this.props.drugs} key={i} />)}
              <a className="drugBtn addDrug" onClick={() => { this.AddDrugForm() }}>ADD DRUG</a>
              <a className="drugBtn addDrug" onClick={() => { this.RemoveDrugForm() }}>REMOVE</a>
            </div>
            <button type="button" className="drugBtn" onClick={(e) => this.submit(e, this.props.bearer, this.props.authenticityToken)}>SUBMIT</button>
          </form>
        </div>
      </div>
    )
  }
}

class DrugFormTemplate extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    console.log()
    return (
      <div name="drug">
        <input type="text" name="usage_description" placeholder="Usage Description" />
        <select>
          {this.props.drugs.map((d) => <option value={d.id} key={d.id}>{d.name}</option>)}
        </select>
      </div>
    )
  }
}
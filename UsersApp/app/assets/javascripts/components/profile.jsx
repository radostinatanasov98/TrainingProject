window.Profile = createReactClass({
  render: function () {
    return (
      <React.Fragment>
        <h1>Examinations of {this.props.user['first_name']} {this.props.user['last_name']}, {this.props.user['email']}</h1>
        <div className="examinationsContainer">
          { this.props.examinations.length > 0 
            ? this.props.examinations.map((e) => <ExamTemplate key={e.id} exam={e} />)
            : <h1>There are no existing examinations.</h1>}
        </div>
      </React.Fragment>
    )
  }
})

ExamTemplate = (props) => {

  expandCard = (e, key) => {
    e.preventDefault()
    if (document.getElementById(key).style.display == 'flex') {
      document.getElementById(key).style.display = 'none'
    } else {
      document.getElementById(key).style.display = 'flex'
    }
  }

  return (
    <div className="examContainer">
      <div className="examContainerHeader">
        <h1>EXAMINATION FROM: {new Date(props.exam['created_at']).toLocaleDateString("en-US")}</h1>
        <button className="expandBtn" onClick={(e) => this.expandCard(e, key = props.exam['id'])}>▼</button>
      </div>
      <div className="cardsContainer" id={props.exam['id']}>
        <div className="examCard">
          <h3>BASIC INFORMATION</h3>
          <div className="dimensionsContainer">
            <label>Weight: {props.exam['weight_kg']}kg.  </label>
            <label>Height: {props.exam['height_cm']}cm.</label>
          </div>
          <label><strong>Anamnesis:</strong> {props.exam['anamnesis']}.</label>
          <p></p>
        </div>
        <div className="examCard midCard">
          <h3>PERSCRIPTION</h3>
          <p>{props.exam['perscription']['description']}</p>
        </div>
        <div className="examCard">
          <h3>DRUGS</h3>
          {props.exam['perscription']['perscription_drug'].map((pd) => <DrugTemplate pd={pd} key={`${pd.drug_id}` + `${pd.perscription_id}`}/>)}
        </div>
      </div>
    </div>
  )
}

DrugTemplate = (props) => {
  return (
    <div className="drug">
      <h4>{props.pd['drug']['name']}</h4>
      <h5>Description</h5>
      <p>{props.pd['drug']['description']}</p>
      <h5>How To Use</h5>
      <p>{props.pd['usage_description']}</p>
    </div>
  )
}
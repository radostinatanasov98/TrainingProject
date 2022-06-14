window.AllPatients = createReactClass({
    render: function () {
        function Card(props) {
            const createExaminationLink = "doctors/create_examination?id=" + props.patient['id']
            const createProfileLink = "profile?id=" + props.patient['id']

            return (
                <div className="card_container">
                        <div className="card">
                            <div className="card_content">
                                <h3 className="card_header">{props.patient['first_name']} {props.patient['last_name']}</h3>
                                <p className="card_info">Address: {props.patient['address']}</p>
                                <p className="card_info">Date of Birth: {props.patient['date_of_birth']}</p>
                            </div>
                        </div>
                    <div className="buttonDiv">
                        <a className="card_button" href={createProfileLink}>VIEW</a>
                        <a className="card_button" href={createExaminationLink}>EXAMINATE</a>
                    </div>
                </div>)
        }

        const patients = this.props.patients

        return (
            <div className="patients_container">
                {patients.map((p) => <Card patient={p} key={p.id} />)}
            </div>
        )
    }
})
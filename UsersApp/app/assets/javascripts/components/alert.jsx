window.Alert = createReactClass({
    render: function () {

        function hide() {
            this.document.getElementsByClassName('alert')[0].style.display = 'none';
        }

      return (
        <div className="alert">
          <strong>{this.props.alert} {this.props.notice}</strong>
          <button onClick={hide}>✘</button>
        </div>
      )
    }
  })
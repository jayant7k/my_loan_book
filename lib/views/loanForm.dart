import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/loaninfo.dart';
import 'package:intl/intl.dart';

class MyLoanInfo extends StatefulWidget {
  @override
  _MyLoanInfoState createState(){
    return _MyLoanInfoState();
  }
}

class _MyLoanInfoState extends State<MyLoanInfo>{
  final _loanFormKey = GlobalKey<FormBuilderState>();
  final _loanInfo = LoanInfo();

  repaintForm(formState, loanInfo, type, val){
    if(type == "p"){
      loanInfo.principal = num.parse(val);
      num emi = loanInfo.calculateEmi(num.parse(val), loanInfo.interest, loanInfo.tenure);
      loanInfo.emi = emi;
      print("New EMI "+emi.toString());
      formState.setAttributeValue("emi", emi.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text('Loan Information')),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FormBuilder(
                    key: _loanFormKey,
                    initialValue: {
                      'loan_name' : _loanInfo.loanName,
                      'principal' : _loanInfo.principal.toString(),
                      'interest' : _loanInfo.interest.toString(),
                      'start_date' : _loanInfo.startDate,
                      'tenure' : _loanInfo.tenure.toString(),
                      'emi' : _loanInfo.emi.toStringAsFixed(2),
                    },
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        FormBuilderTextField(
                          attribute: 'loan_name',
                          decoration: InputDecoration(
                              labelText: "Loan Name",
                              hintText: "Enter a name for the loan",
                              icon: const Icon(Icons.account_balance)
                          ),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: 'principal',
                          decoration: InputDecoration(
                              labelText: "Loan Amount",
                              hintText: "Enter loan amount",
                              icon: const Icon(Icons.attach_money)
                          ),
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.numeric()
                          ],
                          onChanged: (val){
                            repaintForm(_loanFormKey.currentState, _loanInfo, "p", val);
                            _loanFormKey.currentState.setState(() => {

                            });
                          },
                        ),
                        FormBuilderTextField(
                          attribute: 'interest',
                          decoration: InputDecoration(
                              labelText: "Interest %",
                              hintText: "Enter rate of interest",
                              icon: const Icon(Icons.rate_review)
                          ),
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(100),
                          ],
                        ),
                        FormBuilderDateTimePicker(
                          attribute: 'start_date',
                          decoration: InputDecoration(
                              labelText: "Start date",
                              hintText: "Enter date of getting loan",
                              icon: const Icon(Icons.date_range)
                          ),
                          inputType: InputType.date,
                          format: DateFormat("dd-MM-yyyy"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: 'tenure',
                          decoration: InputDecoration(
                              labelText: "Tenure (in years)",
                              hintText: "Enter tenure of loan in Years",
                              icon: const Icon(Icons.timelapse)
                          ),
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(100),
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: 'emi',
                          decoration: InputDecoration(
                              labelText: "EMI",
                              icon: const Icon(Icons.account_balance_wallet)
                          ),
                          //keyboardType: TextInputType.number,
                          readOnly: true,
                          validators: [
                            FormBuilderValidators.numeric(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            "Recalculate",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            //_loanInfo.calcLoanDetails();
                            var _form = _loanFormKey.currentState;
                            _loanInfo.loanName = _form.value["loan_name"];
                            _loanInfo.principal = num.parse(_form.value["principal"]);
                            _loanInfo.interest = num.parse(_form.value["interest"]);
                            _loanInfo.startDate = _form.value["start_date"];
                            _loanInfo.tenure = num.parse(_form.value["tenure"]);
                            _loanInfo.emi = num.parse(_form.value["emi"]);
                            print(_loanInfo.toString());
                            print(_loanFormKey.currentState.toString());
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: MaterialButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            var _form = _loanFormKey.currentState;
                            if (_form.validate()) {
                              _form.save();
                              print(_form.value);
                              _loanInfo.loanName = _form.value["loan_name"];
                              _loanInfo.principal = num.parse(_form.value["principal"]);
                              _loanInfo.interest = num.parse(_form.value["interest"]);
                              _loanInfo.startDate = _form.value["start_date"];
                              _loanInfo.tenure = num.parse(_form.value["tenure"]);
                              _loanInfo.emi = num.parse(_form.value["emi"]);
                              _loanInfo.save();
                            } else {
                              print(_form.value);
                              print("validation failed");
                            }
                            print(_form.value['loan_name'].runtimeType);
                          },
                        ),
                      ),
                    ],
                  )
                ]
            ),
          ),
        )
    );
  }
}

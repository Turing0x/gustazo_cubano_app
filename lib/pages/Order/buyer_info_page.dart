import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class BuyerInfoPage extends StatefulWidget {
  const BuyerInfoPage({super.key, required this.dataOrder});

  final Map<String, dynamic> dataOrder;

  @override
  State<BuyerInfoPage> createState() => _BuyerInfoPageState();
}

class _BuyerInfoPageState extends State<BuyerInfoPage> with TickerProviderStateMixin {
  TextEditingController fullname = TextEditingController();
  TextEditingController ci = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  TextEditingController secfullname = TextEditingController();
  TextEditingController secpostalCode = TextEditingController();
  TextEditingController secphoneNumber = TextEditingController();
  TextEditingController secaddress = TextEditingController();

  String selectedValue = 'Seleccione una de las opciones';
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "Seleccione una de las opciones",
          child: dosisText('Seleccione una de las opciones', fontWeight: FontWeight.bold)),
      DropdownMenuItem(
          value: "TCP - Trabajador x cta propia",
          child: dosisText('TCP - Trabajador x cta propia', fontWeight: FontWeight.bold)),
      DropdownMenuItem(
          value: "PDL - Proyecto de Desarrollo Local",
          child: dosisText('PDL - Proyecto de Desarrollo Local', fontWeight: FontWeight.bold)),
      DropdownMenuItem(
          value: "CNA - Cooperativa No Agropecuaria",
          child: dosisText('CNA - Cooperativa No Agropecuaria', fontWeight: FontWeight.bold)),
      DropdownMenuItem(
          value: "EES - Empresa Estatal Socialista",
          child: dosisText('EES - Empresa Estatal Socialista', fontWeight: FontWeight.bold)),
      DropdownMenuItem(value: "MPM - Mipyme", child: dosisText('MPM - Mipyme', fontWeight: FontWeight.bold)),
      DropdownMenuItem(
          value: "PN - Persona Natural", child: dosisText('PN - Persona Natural', fontWeight: FontWeight.bold)),
      DropdownMenuItem(
          value: "CCS - Cooperativa de Créditos y Servicios",
          child: dosisText('CCS - Cooperativa de Créditos y Servicios', fontWeight: FontWeight.bold)),
    ];
    return menuItems;
  }

  late TabController tabController;
  int _activeIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );

    tabController.addListener(() {
      setState(() {
        _activeIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final nav = Navigator.of(context);

    var boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 1)]);

    var boxDecoration2 = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: const Border(bottom: BorderSide(width: 2, color: Colors.blue)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 1)]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              Container(
                height: size.height * 0.25,
                margin: EdgeInsets.only(left: size.width * .05, right: size.width * .05, bottom: 20),
                child: Image.asset('lib/assets/images/buyer_info.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: dosisText('Necesitamos que nos facilites información acerca del comprador',
                    size: 18, maxLines: 4, textAlign: TextAlign.center),
              ),
              Visibility(
                visible: (widget.dataOrder['type_coin'] == 'ZELLE'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      decoration: (_activeIndex == 1) ? boxDecoration : boxDecoration2,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, side: const BorderSide(color: Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              tabController.index = 0;
                            });
                          },
                          child: dosisText('Quién recibe')),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 40,
                      decoration: (_activeIndex == 0) ? boxDecoration : boxDecoration2,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, side: const BorderSide(color: Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              tabController.index = 1;
                            });
                          },
                          child: dosisText('Quién paga')),
                    ),
                  ],
                ),
              ),
              Visibility(visible: (widget.dataOrder['type_coin'] != 'ZELLE'), child: clientInfo()),
              Visibility(
                visible: (widget.dataOrder['type_coin'] == 'ZELLE'),
                child: SizedBox(
                  height: 500,
                  child: DefaultTabController(
                    length: 2,
                    child: TabBarView(
                      controller: tabController,
                      children: [clientInfo(), clientInfoZelle()],
                    ),
                  ),
                ),
              ),
              actionBtn(context, nav),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton actionBtn(BuildContext context, NavigatorState nav) {
    return ElevatedButton.icon(
        onPressed: () async {
          final orderCrtl = OrderControllers();
          final rProdList = ShoppingCartProvider();

          String getfullname = fullname.text;
          String getci = ci.text;
          String getaddress = address.text;
          String getphoneNumber = phoneNumber.text;

          String getsecfullname = secfullname.text;
          String getsecpostalCode = secpostalCode.text;
          String getsecphoneNumber = secphoneNumber.text;
          String getsecaddress = secaddress.text;

          if (getfullname.isEmpty || getci.isEmpty || getaddress.isEmpty || getphoneNumber.isEmpty) {
            simpleMessageSnackBar(context, texto: 'Todos los campos son obligatorios', typeMessage: false);
            return;
          }

          if (widget.dataOrder['type_coin'] == 'ZELLE') {
            if (getsecfullname.isEmpty ||
                getsecpostalCode.isEmpty ||
                getsecphoneNumber.isEmpty ||
                getsecaddress.isEmpty) {
              simpleMessageSnackBar(context, texto: 'Todos los campos son obligatorios', typeMessage: false);
              return;
            }
          }

          if (selectedValue == 'Seleccione una de las opciones') {
            simpleMessageSnackBar(context, texto: 'Debe seleccionar su forma de gestión económica', typeMessage: false);
            return;
          }

          widget.dataOrder.addAll({
            'buyer': {
              'economic': selectedValue,
              'full_name': getfullname,
              'ci': getci,
              'phone_number': getphoneNumber,
              'address': getaddress,
            }
          });

          if (widget.dataOrder['type_coin'] == 'ZELLE') {
            widget.dataOrder.addAll({
              'who_pay': {
                'full_name': getsecfullname,
                'postal_code': getsecpostalCode,
                'phone_number': getsecphoneNumber,
                'address': getsecaddress,
              }
            });
          } else {
            widget.dataOrder.addAll({
              'who_pay': {
                'full_name': '',
                'postal_code': '',
                'phone_number': '',
                'address': '',
              }
            });
          }

          await orderCrtl.saveOrder(widget.dataOrder);
          rProdList.clearCart();
          nav.pushReplacementNamed('main_commercial_page');
        },
        icon: const Icon(Icons.done_outline_rounded, color: Colors.green),
        label: dosisText('Confirmar', fontWeight: FontWeight.bold));
  }

  Column clientInfo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          child: DropdownButton(
            value: selectedValue,
            items: dropdownItems,
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxt(controller: fullname, keyboardType: TextInputType.name, label: 'Nombre Completo'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child:
              FormTxt(controller: ci, maxLength: 11, keyboardType: TextInputType.number, label: 'Carnet de Identidad'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxt(
              controller: address, maxLength: 50, keyboardType: TextInputType.name, label: 'Dirección Particular'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxt(
              controller: phoneNumber, maxLength: 8, keyboardType: TextInputType.phone, label: 'Teléfono de Contacto'),
        ),
      ],
    );
  }

  Column clientInfoZelle() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxt(controller: secfullname, keyboardType: TextInputType.name, label: 'Nombre Completo'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxt(
              controller: secpostalCode, maxLength: 11, keyboardType: TextInputType.number, label: 'Código Postal'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxt(
              controller: secaddress, maxLength: 50, keyboardType: TextInputType.name, label: 'Dirección Particular'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: FormTxtPhone(
              controller: secphoneNumber,
              maxLength: 17,
              keyboardType: TextInputType.phone,
              label: 'Teléfono de Contacto'),
        ),
      ],
    );
  }
}

class ShowTabBar extends StatelessWidget {
  const ShowTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: 'Quién Recibe'),
          Tab(text: 'Quién Paga'),
        ],
      ),
    );
  }
}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    this.maxLength = 25,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),
          labelText: label,
        ));
  }
}

class FormTxtPhone extends StatelessWidget {
  const FormTxtPhone({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    this.maxLength = 25,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        keyboardType: keyboardType,
        inputFormatters: [
          MaskedInputFormatter('+1 (###) ### ####'),
        ],
        maxLength: maxLength,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),
          labelText: label,
        ));
  }
}

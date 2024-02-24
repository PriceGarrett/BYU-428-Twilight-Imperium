import 'package:client/create_join/create_join_presenter.dart';
import 'package:client/info/info_panel.dart';
import 'package:client/outlined_letters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAndJoinPage extends StatefulWidget {
  const CreateAndJoinPage({super.key});

  @override
  State<CreateAndJoinPage> createState() => _CreateAndJoinPageState();
}

class _CreateAndJoinPageState extends State<CreateAndJoinPage> implements CreateAndJoinPageView {

  late CreateAndJoinPagePresenter _presenter;

  bool buttonsActive = true;

  @override
  void initState() {
    super.initState();
    _presenter = CreateAndJoinPagePresenter(this);
  }

  Gradient titleGradiant = const LinearGradient(
    colors: [Colors.amber, Colors.orange]
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.jpg'),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        children: [
          //Used to ensure the background is 100% of the screen
          const SizedBox(width: double.infinity),
          //Title
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => titleGradiant.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: const Text('TWILIGHT IMPERIUM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 100.0,
                fontFamily: 'Ambroise Firmin'
              ),
            ),
          ),
          //Subtitle
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => titleGradiant.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: const Text('Pax Magnifica, Bellum Gloriosum',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50.0,
                fontFamily: 'Handel Gothic D'
              ),
            ),
          ), 
          //Input Boxes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                child: Column(
                  children: _buildInputColumn()
                ),
              ),
            ),
          ),
          //Selection Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildButtonRow(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildInputColumn() {
    const TextStyle inputStyle = TextStyle(
      color: Colors.amber,
    );
    const InputDecoration inputDecoration = InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black)
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amberAccent)
      )
    );
    return [
      const OutlinedLetters(content: 'Input Room Name'),
      SizedBox(
        width: 300,
        height: 70,
        child: TextField(
          onChanged: (text) {
            _presenter.saveCode(text);
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(20)
          ],
          textAlign: TextAlign.center,
          style: inputStyle,
          cursorColor: Colors.amberAccent,
          decoration: inputDecoration,
        ),
      ),
      const OutlinedLetters(content: 'Input Room Password'),
      SizedBox(
        width: 300,
        height: 70,
        child: TextField(
          onChanged: (text) {
            _presenter.savePassword(text);
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(20)
          ],
          obscureText: true,
          textAlign: TextAlign.center,
          style: inputStyle,
          cursorColor: Colors.amberAccent,
          decoration: inputDecoration,
        ),
      ),
    ];
  }

  List<Widget> _buildButtonRow() {
    List<Widget> protoReturn = [
      TextButton(
        onPressed: buttonsActive ? () {
          _presenter.joinGame();
        } : null,
        style: TextButton.styleFrom(
          backgroundColor: Colors.amber,
          disabledBackgroundColor: Colors.grey         
        ),
        child: const Text('Join Game',
          style: TextStyle(color: Colors.black),
        )
      ),
      TextButton(
        onPressed: buttonsActive ? () {
          _presenter.createGame();
        } : null,
        style: TextButton.styleFrom(
          backgroundColor: Colors.amber,
          disabledBackgroundColor: Colors.grey         
        ),
        child: const Text('Create Game',
          style: TextStyle(color: Colors.black),
        )
      )
    ];
    List<Widget> toReturn = [];
    for(int i = 0; i < protoReturn.length; i++) {
      toReturn.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: protoReturn[i],
        )
      );
    }
    return toReturn;
  }

  @override
  void swapToBoard() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const InfoPanel())
    );
  }

  @override
  void postToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 1500),
      )
    );
  }

  @override
  void setButtonState(bool state) {
    setState(() {
      buttonsActive = state;
    });
  }
}
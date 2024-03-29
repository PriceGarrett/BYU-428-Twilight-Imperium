import 'package:client/info/objective_view.dart';
import 'package:client/info/player_overview.dart';
import 'package:client/info/strategy_card.dart';
import 'package:client/model/objective.dart';
import 'package:client/model/player.dart';
import 'package:client/res/hover_tip.dart';
import 'package:client/res/outlined_letters.dart';
import 'package:client/data/strings.dart';
import 'package:flutter/material.dart';

class GlobalInfo extends StatelessWidget {
  final List<Player> players;
  final List<Objective> publicObjectives;

  const GlobalInfo({
    super.key,
    required this.players,
    required this.publicObjectives
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: ListView(
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    //Build n player overview Widgets
    //One non-player info Widget
    List<Widget> toReturn = [];

    for(int i = 0; i < players.length; i++) {
      toReturn.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
          child: PlayerOverview(
            race: players[i].getName(),
            strategyCardId: players[i].getStrategyCard(),
            tacticTokenCount: players[i].getTacticPool(),
            fleetTokenCount: players[i].getFleetPool(),
            strategyTokenCount: players[i].getStrategyPool(),
            victoryPoints: players[i].getVictoryPoints(),
            playerColor: i,
          )
        )
      );
    }
    //Divider between Player Overviews and generic global info
    toReturn.add(
      const DecoratedBox(
        decoration: BoxDecoration(
        color: Colors.amber,
        ),
        child: SizedBox(
          height: 5.0,
        )
      )
    );
    //Untaken Strategy Cards
    toReturn.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 5.0),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black54),
          child: Row(
            children: _buildUntakenRow(),
          ),
        ),
      )
    );

    toReturn.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 10.0),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black54),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: _buildPublicObjectives(),
            ),
          ),
        ),
      )
    );

    return toReturn;
  }

  List<Widget> _buildUntakenRow() {
    List<Widget> toReturn = [
      const SizedBox(
        width: 0.0,
        height: 70.0,
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: HoverTip(
          message: Strings.strategyCardDesc,
          child: OutlinedLetters(
            content: Strings.untakenStrategyCards
          ),
        ),
      ),
    ];
    List<int> untaken = _getUntakenStrategyCards(players);
    for(int id in untaken) {
      toReturn.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: StrategyCard(
            strategyCardId: id,
            cardHeight: 50.0,
            cardWidth: 30.0,
          ),
        )
      );
    }

    return toReturn;
  }

  List<Widget> _buildPublicObjectives() {

    //Title for section
    List<Widget> toReturn = [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: HoverTip(
          message: Strings.publicObjectiveDesc,
          child: OutlinedLetters(content: Strings.publicObjectives)
        ),
      )
    ];

    List<Widget> toInsert = [];

    for(int i = 0; i < 10; i++) {
      int value = (i < 5) ? 1 : 2;
      if(i < publicObjectives.length) {
        toInsert.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ObjectiveView(
              value: publicObjectives[i].getValue(),
              child: OutlinedLetters(content: '${publicObjectives[i].numPlayersCompleted()}'),
            ),
          )
        );
      }
      else {
        toInsert.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ObjectiveView(
              value: value,
            ),
          )
        );
      }      
    }

    int split = toInsert.length ~/ 2;
    
    toReturn.add(
      Column(
        children: [
          Row(
            children: toInsert.sublist(0, split),
          ),
          Row(
            children: toInsert.sublist(split, toInsert.length),
          )
        ]
      )
    );

    return toReturn;
  }

  List<int> _getUntakenStrategyCards(List<Player> players) {
    Set<int> cards = { 1, 2, 3, 4, 5, 6, 7, 8 };
    for(Player p in players) {
      cards.remove(p.getStrategyCard());
    }
    return cards.toList();
  }
}


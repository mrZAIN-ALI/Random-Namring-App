import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 67, 132, 69)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: mainPageWidget(),
            ),
          ),
        ],
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
   void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favWords = <WordPair>[];

  void toggleFav(){
    if(favWords.contains(current))
    {
      favWords.remove(current);
    }
    else{
      favWords.add(current);
    }

    notifyListeners();
  }
}

class mainPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pairOfWordsGenerated=appState.current;
    IconData favIcon;
    if(appState.favWords.contains(pairOfWordsGenerated)){
      favIcon=Icons.favorite;
    }
    else{
      favIcon=Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            Text('A random idea:'),
            WordPairDecoration(RandomPairOfWordsGenerated: pairOfWordsGenerated),
            SizedBox(height: 10,),  
            
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                ElevatedButton.icon(
                  
                  onPressed: (){
                    appState.toggleFav();
                  }, 
                  label: Text("Favourite"),
                  icon: Icon(favIcon),
                ),

                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WordPairDecoration extends StatelessWidget {
  const WordPairDecoration({
    super.key,
    required this.RandomPairOfWordsGenerated,
  });

  final WordPair RandomPairOfWordsGenerated ;

  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    var thexttheme=Theme.of(context).textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          RandomPairOfWordsGenerated.asPascalCase,
          style: thexttheme,
          semanticsLabel: "${RandomPairOfWordsGenerated.first} ${RandomPairOfWordsGenerated.second}",
        ),
      ),
    );
  }
}
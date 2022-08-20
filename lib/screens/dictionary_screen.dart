// ignore_for_file: prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student_handbook/constant.dart';
import 'package:student_handbook/models/dictionary.dart';
import 'package:student_handbook/services/dictionary_service.dart';
import 'package:student_handbook/widgets/custom_appbar.dart';
import 'package:student_handbook/widgets/my_text_field.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  TextEditingController controller = TextEditingController();

  AudioPlayer? audioPlayer;

  @override
  void initState() {
    super.initState();
    setState(() {
      audioPlayer = AudioPlayer();
    });
  }

  void playAudio(String music) {
    audioPlayer!.stop();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backGroundColor: kPrimaryColor,
        title: "Dictionary",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        icon: Icons.search,
                        showicon: false,
                        hint: 'Search',
                        validator: (validator) {
                          return null;
                        },
                        textEditingController: controller,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              controller.text.isEmpty
                  ? SizedBox(
                      child: _nosearchwidget(),
                    )
                  : FutureBuilder(
                      future:
                          DictionaryService().getMeaning(word: controller.text),
                      builder: (context,
                          AsyncSnapshot<List<DictionaryModel>> snapshot) {
                        debugPrint("Data $snapshot");
                        if (snapshot.hasError) {
                          _nodatawidget();
                        }
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data![index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(data.word!),
                                      subtitle:
                                          Text(data.phonetics![index].text!),
                                      trailing: IconButton(
                                        onPressed: () {
                                          final path =
                                              data.phonetics![index].audio;

                                          playAudio("https:$path");
                                        },
                                        icon: Icon(Icons.audiotrack),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        data.meanings![index]
                                            .definitions![index].definition!,
                                      ),
                                      subtitle: Text(
                                          data.meanings![index].partOfSpeech!),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nodatawidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/clipboard.png',
            height: 299,
          ),
          SizedBox(height: 3),
          Text(
            'Search for Words',
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 45),
          ),
        ],
      ),
    );
  }

  Widget _nosearchwidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Dictionary-pana.png',
            height: 250,
          ),
          SizedBox(height: 3),
          Text(
            'No words found',
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 45),
          ),
        ],
      ),
    );
  }
}

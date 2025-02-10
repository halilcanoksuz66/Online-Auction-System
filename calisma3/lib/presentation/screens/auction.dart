import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/repositories/profile_controller.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/presentation/widgets/fetch_data.dart';
import 'package:calisma3/presentation/widgets/post_card.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Auction extends ConsumerStatefulWidget {
  final PostModel postModel;
  final UserModel userModel;

  const Auction({
    super.key,
    required this.postModel,
    required this.userModel,
  });

  @override
  AuctionState createState() => AuctionState();
}

class AuctionState extends ConsumerState<Auction> with WidgetsBindingObserver {
  final TextEditingController _offerController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  UserModel user =
      UserModel(name: "", surname: "", username: "", email: "", password: "");

  @override
  void initState() {
    _playBackgroundMusic(); // Uygulama açıldığında müziği başlatma
    widget.postModel.offer ??= "0";
    fetchCurrentUser(ref, _onUserFetched);
    super.initState();
  }

  @override
  void dispose() {
    _offerController.dispose();
    _audioPlayerService.dispose(); // AudioPlayerService dispose ediliyor
    super.dispose();
  }

  Future<void> _playBackgroundMusic() async {
    await _audioPlayerService.playSound(musicMT2);
  }

  void _onUserFetched(UserModel fetchedUserModel) {
    setState(() {
      user = fetchedUserModel;
    });
  }

  int _parseOffer(String offer) {
    if (offer == "0") {
      return 0;
    }
    final parts = offer.split(' \$');
    return int.tryParse(parts.last) ?? 0;
  }

  void _setOffer(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      int oldOffer = _parseOffer(widget.postModel.offer!);
      int newOffer = int.parse(_offerController.text);

      if (newOffer > oldOffer) {
        setState(() {
          widget.postModel.offer = '${user.username} \$$newOffer';
        });
        ref.read(profileControllerProvider).updatePost(widget.postModel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Yeni teklif mevcut tekliften yüksek olmalıdır")),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auction"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: PostCard(
                  post: widget.postModel,
                  user: widget.userModel,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: Text(
                        "EN YÜKSEK TEKLİF",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        " ${widget.postModel.offer}",
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: Center(
                      child: StreamBuilder(
                        stream: widget
                            .postModel.remainingTimeStreamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'Sayaç: ${snapshot.data}',
                              style: const TextStyle(fontSize: 24),
                            );
                          } else {
                            return const Text(
                              'SAYAÇ: 0',
                              style: TextStyle(fontSize: 24),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // Resme tıklandığında showDialog'u çağır
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Offer"),
                          content: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _offerController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Lütfen bir değer girin";
                                }
                                final intValue = int.tryParse(value);
                                if (intValue == null) {
                                  return "Lütfen geçerli bir sayı girin";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Teklifinizi girin",
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => _setOffer(context),
                              child: const Text("Tamam"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blueGrey,
                      ),
                      margin: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SvgPicture.asset(
                          raiseHandSvg,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/bloc/inquiry_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/bloc/inquiry_tap_event.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/bloc/inquiry_tap_state.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/widgets/expanded_column.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/widgets/list_tile.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/widgets/model/inquiry.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  int? selectedIndex;
  bool isExpanded = false;

  final Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: const Color.fromARGB(255, 235, 232, 232),
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: const Color.fromARGB(255, 235, 232, 232),
      ),
      themeMode: ThemeMode.system,
      child: NeumorphicBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: const Color(0xff0097b2),
                centerTitle: true,
                expandedHeight: 70,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    //TODO : handle Navigation
                  },
                ),
                title: Text(
                  'Inquiry Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

              // SliverPersistentHeader(
              //   delegate: NeumorphicHeader(title: 'Inquiry Details'),
              //   pinned: true,
              // ),
              SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: BlocBuilder<InquiryBloc, InquiryState>(
                  builder: (context, state) {
                    int? selectedIndex;
                    bool isExpanded = false;

                    if (state is InquiryTapState) {
                      selectedIndex = state.selectedIndex;
                      isExpanded = state.isExpanded;
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final inquiry = inquiries[index];
                        final thisItemExpanded =
                            selectedIndex == index && isExpanded;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              context.read<InquiryBloc>().add(
                                InquiryTapEvent(
                                  index: index,
                                  selectedIndex: selectedIndex,
                                ),
                              );
                            },
                            child: NeumorphicAnimatedContainer(
                              inquiry: inquiry,
                              isExpanded: thisItemExpanded,
                            ),
                          ),
                        );
                      }, childCount: inquiries.length),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NeumorphicAnimatedContainer extends StatefulWidget {
  const NeumorphicAnimatedContainer({
    super.key,
    required this.inquiry,
    required this.isExpanded,
  });
  final Inquiry inquiry;
  final bool isExpanded;

  @override
  State<NeumorphicAnimatedContainer> createState() =>
      _NeumorphicAnimatedContainerState();
}

class _NeumorphicAnimatedContainerState
    extends State<NeumorphicAnimatedContainer> {
  bool get isExpanded => widget.isExpanded;
  Duration duration = const Duration(milliseconds: 2000);
  @override
  void didUpdateWidget(covariant NeumorphicAnimatedContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: isExpanded ? -4 : 4,
          intensity: 0.8,
          boxShape: isExpanded
              ? NeumorphicBoxShape.roundRect(BorderRadius.circular(22))
              : NeumorphicBoxShape.stadium(),
        ),
        child: AnimatedContainer(
          duration: duration,
          child: isExpanded
              ? ExpandedColumn(inquiry: widget.inquiry)
              : MyListTile(inquiry: widget.inquiry),
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/widgets/expanded_column.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/widgets/list_tile.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class InquiryDetailPage extends StatefulWidget {
  const InquiryDetailPage({super.key});

  @override
  State<InquiryDetailPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<InquiryBloc>().add(LoadInquiries()); // 🔥 Fetch data
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(baseColor: Color(0xFFF8F9FD)),
      darkTheme: const NeumorphicThemeData(baseColor: Color(0xFFF8F9FD)),
      themeMode: ThemeMode.system,
      child: NeumorphicBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                expandedHeight: 70,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFFFFFFFF),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text(
                  'Inquiry Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3B82F6), Color(0xFF5D5FEF)],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              /// 🔥 BlocBuilder for data + expand/collapse
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: BlocBuilder<InquiryBloc, InquiryState>(
                  builder: (context, state) {
                    if (state is InquiryLoading) {
                      return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is InquiryLoaded) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final inquiry = state.inquiries[index];
                          final thisItemExpanded =
                              state.selectedIndex == index && state.isExpanded;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                context.read<InquiryBloc>().add(
                                  InquiryTapEvent(index: index),
                                );
                              },
                              child: NeumorphicAnimatedContainer(
                                inquiry: inquiry,
                                isExpanded: thisItemExpanded,
                              ),
                            ),
                          );
                        }, childCount: state.inquiries.length),
                      );
                    } else if (state is InquiryError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Color(0xFF111827)),
                          ),
                        ),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
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

/// 🔹 Animated container for expanding/collapsing list item
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
  Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFB2DFDB),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child:
            isExpanded
                ? ExpandedColumn(inquiry: widget.inquiry) // show details
                : MyListTile(inquiry: widget.inquiry), // show summary
      ),
    );
  }
}

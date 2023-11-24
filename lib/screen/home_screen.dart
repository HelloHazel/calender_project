import 'package:calender_project/component/component_banner.dart';
import 'package:calender_project/component/main_calendar.dart';
import 'package:calender_project/component/schedule_bottom_sheet.dart';
import 'package:calender_project/component/schedule_card.dart';
import 'package:calender_project/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calender_project/database/drift_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달
              onDaySelected: OnDaySelected, // 날짜가 선택됐을 때 실행할 함수
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDate: selectedDate,
              count: 0,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final schedule = snapshot.data![index];

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const ScheduleCard(
              startTime: 12,
              endTime: 14,
              content: '플러터 공부',
            )
          ],
        ),
      ),
    );
  }

  void OnDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}

import 'dart:developer';

import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:dw_barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_vm.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  var registerAdm = false;

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barberShopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(employeeRegisterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case EmployeeRegisterStateStatus.initial:
          break;
        case EmployeeRegisterStateStatus.success:
          Messages.showSuccess('Colaborador cadastrado com sucesso', context);
          Navigator.of(context).pop();
        case EmployeeRegisterStateStatus.error:
          Messages.showError('Erro ao registrar colaborador', context);
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar colaborador'),
        ),
        body: barberShopAsyncValue.when(
          error: (error, stackTrace) {
            log('Erro ao carregar a página',
                error: error, stackTrace: stackTrace);
            return const Center(
              child: Text('Erro ao carregar a página'),
            );
          },
          loading: () => const BarbershopLoader(),
          data: (data) {
            final BarbershopModel(:openingDays, :openingHours) = data;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Column(
                      children: [
                        const AvatarWidget(),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Checkbox.adaptive(
                                value: registerAdm,
                                onChanged: (value) {
                                  setState(() {
                                    registerAdm = !registerAdm;
                                    employeeRegisterVm
                                        .setRegisterAdm(registerAdm);
                                  });
                                }),
                            const Expanded(
                              child: Text(
                                'Sou administrador e quero me cadastrar como colaborador',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Offstage(
                          offstage: registerAdm,
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: nameEC,
                                validator: registerAdm
                                    ? null
                                    : Validatorless.required(
                                        'Nome obrigatório'),
                                decoration:
                                    const InputDecoration(label: Text('Nome')),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: emailEC,
                                validator: registerAdm
                                    ? null
                                    : Validatorless.multiple([
                                        Validatorless.required(
                                            'E-mail obrigatório'),
                                        Validatorless.email('E-mail inválido'),
                                      ]),
                                decoration: const InputDecoration(
                                    label: Text('E-mail')),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: passwordEC,
                                validator: registerAdm
                                    ? null
                                    : Validatorless.multiple([
                                        Validatorless.required(
                                            'Senha obrigatória'),
                                        Validatorless.min(6,
                                            'Senha deve conter 6 caracteres'),
                                      ]),
                                obscureText: true,
                                decoration:
                                    const InputDecoration(label: Text('Senha')),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        WeekdaysPanel(
                          onDayPressed: employeeRegisterVm.addOrRemoveWorkDays,
                          enableDays: openingDays,
                        ),
                        const SizedBox(height: 24),
                        HoursPanel(
                          startTime: 6,
                          endTime: 23,
                          onHourPressed:
                              employeeRegisterVm.addOrRemoveWorkHours,
                          enableHours: openingHours,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                          ),
                          onPressed: () {
                            switch (formKey.currentState?.validate()) {
                              case false || null:
                                Messages.showError(
                                    'Existem campos inválidos', context);
                              case true:
                                // TODO v1
                                // final EmployeeRegisterState(
                                //   :workDays,
                                //   :workHours
                                // ) = ref.watch(employeeRegisterVmProvider);

                                // if (workDays.isEmpty || workHours.isEmpty) {
                                //   Messages.showError(
                                //       'Por favor selecione os dias da semana e horário de atendimento',
                                //       context);
                                //   return;
                                // }

                                // final name = nameEC.text;
                                // final email = emailEC.text;
                                // final password = passwordEC.text;

                                // employeeRegisterVm.register(
                                //   name: name,
                                //   email: email,
                                //   password: password,
                                // );

                                // TODO v2 com dart 3
                                final EmployeeRegisterState(
                                  workDays: List(isNotEmpty: hasWorkDays),
                                  workHours: List(isNotEmpty: hasWorkHours),
                                ) = ref.watch(employeeRegisterVmProvider);

                                if (!hasWorkDays || !hasWorkHours) {
                                  Messages.showError(
                                      'Por favor selecione os dias da semana e horário de atendimento',
                                      context);
                                  return;
                                }

                                final name = nameEC.text;
                                final email = emailEC.text;
                                final password = passwordEC.text;

                                employeeRegisterVm.register(
                                  name: name,
                                  email: email,
                                  password: password,
                                );
                            }
                          },
                          child: const Text('CADASTRAR COLABORADOR'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

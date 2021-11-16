function ui(model::DatePickers)
  [
    page(
      vm(model),
      class = "container",
      title = "DatePickers Demo",
      partial = true,
      core_theme = true,
      [
        row(cell([h1("Date pickers")]))
        row(
          [
            cell([datepicker(:date),])
            cell([datepicker(:dates, multiple = true), ])
            cell([datepicker(:daterange, range = true), ])
            cell([datepicker(:dateranges, range = true, multiple = true)])
          ],
        )
        row(
          [
            cell([
              btn(
                icon = "event",
                round = true,
                color = "primary",
                [
                  popup_proxy([
                    datepicker(
                      :proxydate,
                      content = [
                        Genie.Renderer.Html.div(
                          class = "row items-center justify-end q-gutter-sm",
                          [
                            btn(
                              label = "Cancel",
                              color = "primary",
                              flat = true,
                              v__close__popup = true,
                            )
                            btn(label = "OK", color = "primary", flat = true, v__close__popup = true,
                            )
                          ],
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ])
            cell([
              Genie.Renderer.Html.div(
                class = "q-pa-md",
                style = "max-width: 300px",
                [
                  textfield(
                    "",
                    :inputdate,
                    filled = true,
                    content = [
                      template(
                        v__slot!!append = true,
                        [
                          icon(
                            name = "event",
                            class = "cursor-pointer",
                            [
                              popup_proxy(
                                ref = "qDateProxy",
                                transition__show = "scale",
                                transition__hide = "scale",
                                [
                                  datepicker(
                                    :inputdate,
                                    content = [
                                      Genie.Renderer.Html.div(
                                        class = "row items-center justify-end",
                                        [
                                          btn(
                                            v__close__popup = true,
                                            label = "Close",
                                            color = "primary",
                                            flat = true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ])
          ],
        )
      ],
    ),
  ]
end

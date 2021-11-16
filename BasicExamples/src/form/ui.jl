Stipple.client_data(m::FormComponent) =
  client_data(client_name = js"null", client_age = js"null", accept = false)


# $-values are linked to the use of Quasar
# defines javascript code block without interpolation and unescaping
Stipple.js_methods(m::FormComponent) = raw"""
    onSubmit () {
      if (this.accept !== true) {
        this.$q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'warning',
          message: 'You need to accept the license and terms first'
        })
      }
      else {
        this.$q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'cloud_done',
          message: 'Submitted'
        });
        this.name = this.client_name;
        this.age = this.client_age;
      }
    },
    onReset () {
      console.log(this.client_name)  // Hit F12 open console and you should see name
      console.log(this.client_age)  // Hit F12 open console tab and you should see age
      this.client_name = null
      this.client_age = null
      this.accept = false
    }
  """

NO = StippleUI.NO_WRAPPER # NO_WRAPPER is anonymous function f->f()

myform() = xelem(
  :div,
  class = "q-pa-md",
  style = "max-width: 400px",
  [
    StippleUI.form(
      [ # <form functioncall takes array of functioncalls <textfield>, <numberfield>, <toggle> & <div wrapping two buttons>

        # Name field
        textfield(
          "What's your name *", :client_name,
          @iif(:warin),
          :filled, # you can also mention it "filled" as string
          hint = "Name and surname",
          "lazy-rules", # if not string you an use julia symbol lazy__rules notice - is replace by two underscores
          rules = "[val => val && val.length > 0 || 'Please type something']",
        ),

        # Age field
        numberfield(
          "Your age *", :client_age,
          "filled",
          :lazy__rules,
          rules = """[
                val => val !== null && val !== '' || 'Please type your age',
                val => val > 0 && val < 100 || 'Please type a real age'
            ]""", # use """ """ or " " rules contain valid javascript rule
        ),

        # Accept license toggle + Submit answer
        toggle("I accept the license and terms", :accept, wrap = NO),
        Stipple.Html.div(
          [
            btn("Submit", type = "submit2", color = "primary", wrap = NO)
            btn(
              "Reset",
              type = "reset",
              color = "primary",
              :flat,
              class = "q-ml-sm",
              wrap = NO,
            )
          ],
        ),

        p(
          "Bad stuff's about {{object}} to happen",
          class = "warning",
          @recur(:"object in objects")
        ),
      ],

      @on(:submit, "onSubmit"),
      @on(:reset, "onReset"),
      class = "q-gutter-md",
      wrap = NO,
    ),  # defined vuejs v-on :submit is binded to onSubmit() javascript function defined below
  ],
)
# @on macro is a mapping to vuejs's v-on ...like wise @showif is mapped to v-show
# v-model is @bind



function ui(model::FormComponent)
  page(vm(model),
  class = "container",
  title = "Hello Stipple",
  myform())
end

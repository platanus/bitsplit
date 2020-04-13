<template id="full">
  <div id="SignUpForm">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent="handleSubmit"
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="mb-4">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="email"
            >
              Email
            </label>
            <inputForm
              fieldId="email"
              fieldType="text"
              fieldPlaceholder="Email"
              fieldName="email"
              v-model = "email"
            />
          </div>
          <div class="mb-4">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="password"
            >
              Password
            </label>
            <passwordInput
              fieldId="password"
              fieldPlaceholder="******************"
              fieldName="password"
              v-model = "password"
            />

            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="password"
            >
              Repeat your password
            </label>
            <passwordInput
              fieldId="confirm_password"
              fieldPlaceholder="******************"
              fieldName="confirm_password"
              v-model = "confirm_password"
            />
          </div>
          <div class="mb-6">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="buda_user"
            >
              Buda User
            </label>
            <inputForm
              fieldId="buda_user"
              fieldType="text"
              fieldPlaceholder="Buda User"
              fieldName="buda_user"
            />
          </div>
          <submitButton :fieldDisabled="false" fieldPlaceholder="Sign Up" />
        </form>
      </div>
    </center>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex'
import inputForm from '../components/Input'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'

export default {
  name: 'SignUp',
  data() {
    return {
      routeName: 'SignUp',
      email: '',
      password: '',
      confirm_password: '',
      buda_user: '',
      loading: false
    }
  },
  components: {
    inputForm,
    passwordInput,
    submitButton
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signUp']),
    handleSubmit(e) {
      const { email, password, confirm_password } = this
      console.log('cosas', email,password, confirm_password)
      if (email && password && password === confirm_password) {
        console.log('Correct confirmation')
        this.signUp({ email, password, buda_user })
          .then(() => {
            // TODO logger
            console.log('success')
          })
          .catch(err => {
            console.log(err)
          })
      }
    }
  }
}
</script>

<style scoped>
#SignUpForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>

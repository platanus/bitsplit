<template id="full">
  <div id="SignUpForm">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent="handleSubmit"
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="mb-4">
            <inputLabel fieldName="Email" fieldFor="email" />
            <inputForm
              fieldId="email"
              fieldType="text"
              fieldPlaceholder="Email"
              fieldName="email"
              v-model="email"
            />
          </div>
          <div class="mb-4">
            <inputLabel fieldName="Password" fieldFor="password" />

            <passwordInput
              fieldId="password"
              fieldName="password"
              v-model="password"
            />
            <inputLabel fieldName="Repeat your password" fieldFor="password" />
            <passwordInput
              fieldId="confirm_password"
              fieldName="confirm_password"
              v-model="confirm_password"
            />
          </div>
          <div class="mb-6">
            <inputLabel fieldName="Buda User" fieldFor="buda_user" />
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
import inputLabel from '../components/InputLabel'

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
    submitButton,
    inputLabel
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signUp']),
    handleSubmit(e) {
      const { email, password, confirm_password } = this
      console.log('cosas', email, password, confirm_password)
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

<template>
  <div id="budaSignInForm">
    <center>
      <div class="w-full max-w-xs">
        <form @submit.prevent="handleSubmit">
          <div>
            <textField textvalue1="¿Estás seguro de querer desconectar tu cuenta Buda? Por favor ingresa tu contraseña para confirmar" />
          </div>
          <div>
            <inputLabel fieldName="Contraseña Bitsplit" fieldFor="password" />
            <passwordInput fieldId="password" fieldName="password" v-model="password"/>
          </div>
          <div>
            <submitButton :fieldDisabled="false" fieldPlaceholder="Confirmar" />
          </div>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import textInput from '../components/Input.vue'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'
import inputLabel from '../components/InputLabel'
import textField from '../components/TextField'

export default {
  name: 'BudaLogoutForm',
  data() {
    return {
      routeName: 'BudaLogoutForm',
      api_key: '',
      api_secret: '',
      password: ''
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel,
    textField
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['budaSignIn']),
    handleSubmit(e) {
      const { api_key, api_secret, password } = this
      if ( password ) {
        const { email, authentication_token } = this.currentUser
        this.budaSignIn({ api_key, api_secret, password, email, authentication_token })
          .then(() => {
            console.log('success')
            this.$router.push('/home')
          })
          .catch(err => {
            console.error(err)
          })
      }
    }
  }
}
</script>

<style scoped>
#budaSignInForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>
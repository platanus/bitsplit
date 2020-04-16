<template>
  <div id="budaSignInForm">
    <center>
      <div class="w-full max-w-xs">
        <form @submit.prevent="handleSubmit">
          <div>
            <p class="block text-gray-700 text-sm font-bold mb-5">Ingresa el API_KEY y API_SECRET de tu cuenta Buda. Puedes acceder a ellos en tu perfil de <a href="https://www.buda.com" target="_blank">www.buda.com</a></p>
          </div>
          <div>
            <inputLabel fieldName="API_KEY" fieldFor="key" />
            <passwordInput fieldId="api_key" fieldName="api_key" v-model="api_key"/>
          </div>
          <div>
            <inputLabel fieldName="API_SECRET" fieldFor="api_secret" />
            <passwordInput fieldId="api_secret" fieldName="api_secret" v-model="api_secret"/>
          </div>
          <div>
            <inputLabel fieldName="Confirma tu contraseña Bitsplit" fieldFor="password" />
            <passwordInput fieldId="password" fieldName="password" v-model="password"/>
          </div>
          <div>
            <submitButton :fieldDisabled="false" fieldPlaceholder="Sincronizar Buda" />
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

export default {
  name: 'BudaForm',
  data() {
    return {
      routeName: 'BudaForm',
      api_key: '',
      api_secret: '',
      password: ''
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['budaSignIn']),
    handleSubmit(e) {
      const { api_key, api_secret, password } = this
      if (api_key && api_secret && password) {
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
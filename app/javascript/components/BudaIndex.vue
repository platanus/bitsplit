<template>
  <div id="budaSignInForm">
    <center>
      <div class="w-full max-w-xs">
        <div>
          <textField textvalue1="¡Ya estás conectado a una cuenta Buda! ¿Qué desear hacer?" />
        </div>
        <div class=inline>
          <div class="pb-6">
            <submitButton @do-click="change('BudaForm')" 
            wide="full" color="secondary" :fieldDisabled="false" fieldPlaceholder="Actualizar Keys" />
          </div>
          <div class="pb-6">
            <submitButton @do-click="change('BudaLogoutForm')" 
            wide="full" color="secondary" :fieldDisabled="false" fieldPlaceholder="Desconectar Buda" />
          </div>
        </div>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from 'vuex'
import textInput from '../components/Input.vue'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'
import inputLabel from '../components/InputLabel'
import textField from '../components/TextField'

export default {
  name: 'budaIndex',
  data() {
    return {
      routeName: 'budaIndex',
      api_key: '',
      api_secret: '',
      password: '',
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel,
    textField
  },
  methods: {
    ...mapActions('component', ['changeProfileComp']),
    change(form) {
      this.changeProfileComp(form)
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
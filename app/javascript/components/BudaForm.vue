<template>
  <div class="mt-16">
    <center>
      <div class="w-full max-w-xs">
        <form @submit.prevent="handleSubmit">
          <div>
            <textField>
              Ingresa el API_KEY y API_SECRET de tu cuenta Buda. Puedes acceder a ellos en tu perfil de <a href="https://www.buda.com">www.buda.com</a>
            </textField>
          </div>
          <div>
            <inputLabel field-name="API_KEY">
              key
            </inputLabel>
            <passwordInput
              field-id="apiKey"
              field-name="apiKey"
              v-model="apiKey"
            />
          </div>
          <div>
            <inputLabel field-name="API_SECRET">
              apiSecret
            </inputLabel>
            <passwordInput
              field-id="apiSecret"
              field-name="apiSecret"
              v-model="apiSecret"
            />
          </div>
          <div>
            <inputLabel field-for="password">
              Confirma tu contraseña Bitsplit
            </inputLabel>
            <passwordInput
              field-id="password"
              field-name="password"
              v-model="password"
            />
          </div>
          <div>
            <submitButton :loading="budaSignInLoading">
              Sincronizar Buda
            </submitButton>
          </div>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import passwordInput from '../components/PasswordInput';
import submitButton from '../components/SubmitButton';
import inputLabel from '../components/InputLabel';
import textField from '../components/TextField';

export default {
  name: 'BudaForm',
  data() {
    return {
      routeName: 'BudaForm',
      apiKey: '',
      apiSecret: '',
      password: '',
    };
  },
  components: {
    passwordInput,
    submitButton,
    inputLabel,
    textField,
  },
  computed: {
    ...mapState('user', ['currentUser', 'budaSignInLoading']),
  },
  methods: {
    ...mapActions('user', ['budaSignIn']),
    handleSubmit() {
      const { apiKey, apiSecret, password } = this;
      if (apiKey && apiSecret && password) {
        this.budaSignIn({
          api_key: apiKey,
          api_secret: apiSecret,
          password,
        })
          .then(() => {
            this.$router.push('/home');
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
  },
};
</script>

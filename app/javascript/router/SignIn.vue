<template id="full">
  <div class="mt-16">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent="handleSubmit"
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="mb-4">
            <inputLabel field-for="email">
              Email
            </inputLabel>
            <textInput
              field-id="email"
              field-type="text"
              field-placeholder="Email"
              field-name="email"
              v-model="email"
            />
          </div>
          <div class="mb-4">
            <inputLabel field-for="password">
              Contraseña Bitsplit
            </inputLabel>
            <passwordInput
              field-id="password"
              field-name="password"
              v-model="password"
            />
          </div>
          <submitButton :loading="signInLoading">
            Log In
          </submitButton>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import textInput from '../components/Input';
import passwordInput from '../components/PasswordInput';
import submitButton from '../components/SubmitButton';
import inputLabel from '../components/InputLabel';

export default {
  name: 'SignIn',
  data() {
    return {
      routeName: 'Sign In',
      email: '',
      password: '',
    };
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel,
  },
  computed: {
    ...mapState('user', ['currentUser', 'signInLoading']),
  },
  methods: {
    ...mapActions('user', ['signIn']),
    handleSubmit() {
      const { email, password } = this;
      if (email && password) {
        this.signIn({ email, password })
          .then(() => {
            // TODO logger
          })
          .catch(() => {
            console.error('error');
          });
      }
    },
  },
};
</script>

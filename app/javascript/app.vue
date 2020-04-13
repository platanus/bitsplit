  <template>
  <div id="vue-app">
    <navBar></navBar>
    <alert-message></alert-message>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import navBar from 'components/navBar.vue'
import alertMessage from 'components/alerts/alertMessage.vue'
export default {
  name: 'app',
  components: {
    navBar,
    alertMessage
  },
  methods: {
    ...mapActions('alert', ['clear_alert'])
  }
}
</script>

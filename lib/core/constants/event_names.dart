// these static event names can be used to log events to multiple analytics providers
// like firebase analytics, mixpanel
class EventNames {
  static const clickLogout = "click_logout";
  static const clickNewConversation = "click_new_conversation";
  static const clickDeleteConversation = "click_delete_conversation";
  // event:  user opens a chat from conversations list screen
  static const clickOpenChat = "click_open_chat";
  // event:  user sends a msg by clicking msg send button
  static const clickMessageSend = "click_message_send";
  // event: user clicking country code choosing field
  static const clickCountryCode = "click_country_code";
  static const clickResendOTP = "click_resend_otp";
  // event: to log when user is in auth verified state after otp verification
  // and receiving access token from backend
  static const login = "login";
  // event: to log when user receives error after providing otp (example: invalid otp)
  static const otpVerificationError = "otp_verification_error";
  // event: to log when firebase provides error msg on why otp wont be sent
  // (example: tried sending otp too many times)
  static const otpNotSentError = "otp_not_sent_error";
}

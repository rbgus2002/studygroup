package ssu.groupstudy.domain.user.api;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

//class UserApiTest extends ApiTest {
//    @InjectMocks
//    private UserController userApi;
//    @Mock
//    private UserService userService;
//
//    @BeforeEach
//    public void init() {
//        mockMvc = MockMvcBuilders.standaloneSetup(userApi)
//                .setControllerAdvice(new GlobalExceptionHandler())
//                .build();
//
//    }
//
//    @Nested
//    class 회원가입{
//        @DisplayName("이메일 형식이 아닌 경우 예외를 던진다.")
//        @ParameterizedTest
//        @ValueSource(strings = {"rbgus2002", "rbgus2002@", "naver.com"})
//        void fail_invalid_Email(String email) throws Exception {
//            // given
//            final String url = "/user";
//            final SignUpReqVo 최규현SignUpReqVo = new SignUpReqVo("최규현", "규규", "", "", email);
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(최규현SignUpReqVo))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }
//    }
//
//
//    @Nested
//    class 사용자조회{
//        @DisplayName("성공")
//        @Test
//        void success() throws Exception {
//            // given
//            final String url = "/user";
//            final SignUpReqVo 최규현SignUpReqVo = new SignUpReqVo("최규현", "규규", "", "", "rbgus2002@naver.com");
//            final UserEntity 최규현 = 최규현SignUpReqVo.toEntity();
//            doReturn(UserInfoResVo.from(최규현)).when(userService).findUser(any(Long.class));
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.get(url)
//                    .param("userId", "-1")
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isOk());
//
//            DataResVo response = gson.fromJson(resultActions.andReturn()
//                    .getResponse()
//                    .getContentAsString(StandardCharsets.UTF_8), DataResVo.class);
//            assertThat(response.getSuccess()).isTrue();
//            assertThat(response.getData().get("user")).isNotNull();
//        }
//    }
//}
package ssu.groupstudy.domain.round.api;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.common.ApiTest;
import ssu.groupstudy.domain.round.service.RoundService;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class RoundApiTest extends ApiTest {
    @InjectMocks
    private RoundApi roundApi;

    @Mock
    private RoundService roundService;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(roundApi)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    // TODO : Gson을 통해 LocalDateTime을 Json으로 만들기 위해선 따로 TypeAdapter 생성해주어야 함
    @Nested
    class 회차생성 {
//        @Test
//        @DisplayName("회차 생성 시에 studyId가 비어있는 경우 예외를 던진다")
//        void 실패_studyId존재X() throws Exception {
//            // given
//            final String url = "/round";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(AppointmentRequest.builder()
//                            .studyPlace("규현집")
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }
//
////        @Test
////        @DisplayName("회차 생성 시에 studyTime 인자의 format은 '2023-05-16 16:50' 와 같이 지정한다")
////        void 실패_studyTime_형식에러() throws Exception {
////            // given
////            final String url = "/round";
////
////            // when
////            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
////            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
////                    .content(gson.toJson(AppointmentRequest.builder()
////                            .studyTime(LocalDateTime.parse("2023-05-17 16:00", formatter))
////                            .studyId(-1L)
////                            .build()))
////                    .contentType(MediaType.APPLICATION_JSON)
////            );
////
////            // then
////            resultActions.andExpect(status().isBadRequest());
////        }
//
//        @Test
//        @DisplayName("성공")
//        void 성공() throws Exception {
//            // given
//            final String url = "/round";
//            doReturn(getCreateRoundRequest().toEntity(getStudy())).when(roundService).createRound(any(AppointmentRequest.class));
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(AppointmentRequest.builder()
//                            .studyPlace("규현집")
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isOk());
//
//            DataResponseDto response = gson.fromJson(resultActions.andReturn()
//                    .getResponse()
//                    .getContentAsString(StandardCharsets.UTF_8), DataResponseDto.class);
//
//            assertThat(response.getData().get("notice")).isNotNull();
//        }
    }
}
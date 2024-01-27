package com.gdsc.solutionchallenge.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.security.Principal;

@Builder
@Getter
public class OldestDiaryResponseDto {
    private Long id;
    private String shareDiary;
    private String emotion;
}
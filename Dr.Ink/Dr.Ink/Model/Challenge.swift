//
//  Challenge.swift
//  Dr.Ink
//
//  Created by Inwoo Park on 2022/05/09.
//

import Foundation

enum Challenge: Hashable, Codable {
    case rowCaffeine, sugarFree
    
    var title: String {
        switch self {
        case .rowCaffeine:
            return "저카페인으로 마시기"
        case .sugarFree:
            return "무설탕으로 마시기"
        }
    }
    
    var advantage: String {
        switch self {
        case .rowCaffeine:
            return "일상적인 에너지 공급원으로 카페인에 의존하는 정도를 낮춰보세요. 카페인은 잠을 깨고 집중력을 높여주는 도구로 활용될 수 있지만 식단에서 카페인을 제거하는 경우의 이점이 더욱 많습니다.\n\n1. 수면개선. 더 빨리 잠들며, 우리 몸을 개운하게 재충전할 수 있는 수면 시간이 더 많이 확보됩니다.\n\n2. 불안과 우울감 감소. 이제 신경계의 '투쟁 혹은 도피' 호르몬의 자극 빈도가 감소할 것입니다.\n\n3. 더 건강하고 하얀 치아. 치아 에나멜 침전 및 변색을 야기하는 산성도와 높은 탄닌 함량으로 인해 유발되는 치아 얼룩이 감소합니다.\n\n4. 두통 감소. 카페인 금단 현상의 부작용일 수 있는 멍한 느낌, 피로, 과민반응도 개선됩니다."
        case .sugarFree:
            return "달콤한 음료를 끊어야 할 몇 가지 이유가 있습니다.\n\n1. 건강한 치아. 구내의 산성 환경을 조성하여 충칠르 유발하는 산 성분에 노출되는 빈도가 감소합니다.\n\n2. 맑은 피부. 설탕 섭취를 줄이면 피부가 개선될 수 있습니다. 설탕 섭취는 여드름과 주름 등의 노화 징후의 위험을 높이는 요인입니다.\n\n3. 에너지 증진. 신체에서 혈당 수치의 급등을 경험하는 빈도가 감소합니다. 혈당 수치가 급등한 이후 급격히 저하하여 에너지 수준의 불안정을 유발할 수 있습니다.\n\n4. 체중 감량. 체중을 늘리는 칼로리 섭취량이 감소합니다.\n\n5. 당뇨병, 심장 또는 혈관 질환, 암의 위험이 감소합니다."
        }
    }
    
    var content: String {
        switch self {
        case .rowCaffeine:
            return "하루 중 카페인의 총 섭취량을 55mg 이하로 유지하세요. 이는 보통 일반 커피나 카푸치노 반 컵, 홍차 한 컵, 녹차 또는 말차 두 컵 분량에 해당합니다. 코카콜라나 펩시 등의 음료에도 카페인이 함유되어 있으므로 에너지 드링크 및 청량음료를 마실 때 주의하셔야 합니다.\n\n매일 수분 섭취 목표를 달성하여 챌린지 연속 기록을 세워보세요."
        case .sugarFree:
            return "설탕이나 감미료(고과당 옥수수 시럽, 자당, 과일 주스 농축액 등)함유 음료 섭취는 자제하세요.\n\n 매일 수분 섭취 목표를 달성하여 챌린지 연속 기록을 세워보세요."
        }
    }
}

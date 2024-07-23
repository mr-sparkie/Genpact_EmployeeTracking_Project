package com.hightech.model;

import java.math.BigDecimal;

public class ChartData {
    private int userId;
    private BigDecimal totalHours;

    public ChartData(int string, BigDecimal totalHours) {
        this.userId = string;
        this.totalHours = totalHours;
    }

    public ChartData(Object userId2, int count) {
		// TODO Auto-generated constructor stub
	}

	public ChartData(String valueOf, BigDecimal totalHours2) {
		// TODO Auto-generated constructor stub
	}

	public int getUserId() {
        return userId;
    }

    public BigDecimal getTotalHours() {
        return totalHours;
    }
}

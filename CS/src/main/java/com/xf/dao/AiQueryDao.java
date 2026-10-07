package com.xf.dao;

import com.xf.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AiQueryDao {
    public List<Map<String, Object>> query(String sql) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setMaxRows(100);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData metaData = rs.getMetaData();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= metaData.getColumnCount(); i++) {
                        row.put(metaData.getColumnLabel(i), rs.getObject(i));
                    }
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Map<String, Object> getSummary() {
        String sql = "select (select count(*) from shopping) as product_count," +
                "(select count(*) from mall_order) as order_count," +
                "(select count(*) from payment where pay_status='支付成功') as paid_count," +
                "(select ifnull(sum(total_amount),0) from mall_order where status in ('已支付','已完成')) as sales_amount," +
                "(select count(*) from shopping where stock<10) as low_stock_count";
        List<Map<String, Object>> list = query(sql);
        return list.isEmpty() ? new LinkedHashMap<>() : list.get(0);
    }
}

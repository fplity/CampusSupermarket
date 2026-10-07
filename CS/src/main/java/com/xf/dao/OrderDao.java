package com.xf.dao;

import com.xf.entity.MallOrder;
import com.xf.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    public List<MallOrder> getAll() {
        String sql = "select o.oid,o.account,o.sid,s.sname,o.quantity,o.total_amount,o.status,o.created_at " +
                "from mall_order o left join shopping s on o.sid=s.sid order by o.created_at desc";
        List<MallOrder> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(readOrder(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<MallOrder> getByAccount(String account) {
        String sql = "select o.oid,o.account,o.sid,s.sname,o.quantity,o.total_amount,o.status,o.created_at " +
                "from mall_order o left join shopping s on o.sid=s.sid where o.account=? order by o.created_at desc";
        List<MallOrder> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(readOrder(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int add(MallOrder order) {
        String productSql = "select price,stock from shopping where sid=? for update";
        String stockSql = "update shopping set stock=stock-? where sid=?";
        String orderSql = "insert into mall_order(oid,account,sid,quantity,total_amount,status) values(?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement productPs = conn.prepareStatement(productSql)) {
                productPs.setString(1, order.getSid());
                try (ResultSet rs = productPs.executeQuery()) {
                    if (!rs.next() || rs.getInt("stock") < order.getQuantity()) {
                        conn.rollback();
                        return 0;
                    }
                    order.setTotalAmount(rs.getDouble("price") * order.getQuantity());
                }
            }
            try (PreparedStatement stockPs = conn.prepareStatement(stockSql);
                 PreparedStatement orderPs = conn.prepareStatement(orderSql)) {
                stockPs.setInt(1, order.getQuantity());
                stockPs.setString(2, order.getSid());
                stockPs.executeUpdate();

                orderPs.setString(1, order.getOid());
                orderPs.setString(2, order.getAccount());
                orderPs.setString(3, order.getSid());
                orderPs.setInt(4, order.getQuantity());
                orderPs.setDouble(5, order.getTotalAmount());
                orderPs.setString(6, "待支付");
                int n = orderPs.executeUpdate();
                conn.commit();
                return n;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int updateStatus(String oid, String status) {
        String sql = "update mall_order set status=? where oid=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, oid);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private MallOrder readOrder(ResultSet rs) throws SQLException {
        MallOrder order = new MallOrder();
        order.setOid(rs.getString("oid"));
        order.setAccount(rs.getString("account"));
        order.setSid(rs.getString("sid"));
        order.setSname(rs.getString("sname"));
        order.setQuantity(rs.getInt("quantity"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getString("created_at"));
        return order;
    }
}

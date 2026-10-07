package com.xf.dao;

import com.xf.entity.Payment;
import com.xf.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentDao {
    public List<Payment> getAll() {
        String sql = "select p.pid,p.oid,o.account,p.pay_amount,p.pay_method,p.pay_status,p.pay_time " +
                "from payment p left join mall_order o on p.oid=o.oid order by p.pay_time desc";
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPid(rs.getString("pid"));
                payment.setOid(rs.getString("oid"));
                payment.setAccount(rs.getString("account"));
                payment.setPayAmount(rs.getDouble("pay_amount"));
                payment.setPayMethod(rs.getString("pay_method"));
                payment.setPayStatus(rs.getString("pay_status"));
                payment.setPayTime(rs.getString("pay_time"));
                list.add(payment);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<Payment> getByAccount(String account) {
        String sql = "select p.pid,p.oid,o.account,p.pay_amount,p.pay_method,p.pay_status,p.pay_time " +
                "from payment p left join mall_order o on p.oid=o.oid where o.account=? order by p.pay_time desc";
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPid(rs.getString("pid"));
                    payment.setOid(rs.getString("oid"));
                    payment.setAccount(rs.getString("account"));
                    payment.setPayAmount(rs.getDouble("pay_amount"));
                    payment.setPayMethod(rs.getString("pay_method"));
                    payment.setPayStatus(rs.getString("pay_status"));
                    payment.setPayTime(rs.getString("pay_time"));
                    list.add(payment);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int add(Payment payment) {
        String orderSql = "select total_amount,status from mall_order where oid=? for update";
        String paymentSql = "insert into payment(pid,oid,pay_amount,pay_method,pay_status) values(?,?,?,?,?)";
        String updateSql = "update mall_order set status='已支付' where oid=?";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement orderPs = conn.prepareStatement(orderSql)) {
                orderPs.setString(1, payment.getOid());
                try (ResultSet rs = orderPs.executeQuery()) {
                    if (!rs.next() || "已支付".equals(rs.getString("status"))) {
                        conn.rollback();
                        return 0;
                    }
                    payment.setPayAmount(rs.getDouble("total_amount"));
                }
            }
            try (PreparedStatement paymentPs = conn.prepareStatement(paymentSql);
                 PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                paymentPs.setString(1, payment.getPid());
                paymentPs.setString(2, payment.getOid());
                paymentPs.setDouble(3, payment.getPayAmount());
                paymentPs.setString(4, payment.getPayMethod());
                paymentPs.setString(5, "支付成功");
                int n = paymentPs.executeUpdate();
                updatePs.setString(1, payment.getOid());
                updatePs.executeUpdate();
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
}

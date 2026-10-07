package com.xf.dao;

import com.xf.entity.Shopping;
import com.xf.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ShoppingDao {
    public List<Shopping> getAll() {
        String sql = "select sid,sname,price,image,stock from shopping order by sid";
        return queryList(sql);
    }

    public List<Shopping> search(String keyword) {
        String sql = "select sid,sname,price,image,stock from shopping where sid like ? or sname like ? order by sid";
        String like = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        return queryList(sql, like, like);
    }

    public int add(Shopping shopping) {
        String sql = "insert into shopping(sid,sname,price,image,stock) values(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            fill(ps, shopping);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int update(Shopping shopping) {
        String sql = "update shopping set sname=?,price=?,image=?,stock=? where sid=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, shopping.getSname());
            ps.setDouble(2, shopping.getPrice());
            ps.setString(3, shopping.getImage());
            ps.setInt(4, shopping.getStock());
            ps.setString(5, shopping.getSid());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int delete(String sid) {
        String sql = "delete from shopping where sid=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sid);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private List<Shopping> queryList(String sql, String... params) {
        List<Shopping> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setString(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Shopping shopping = new Shopping();
                    shopping.setSid(rs.getString("sid"));
                    shopping.setSname(rs.getString("sname"));
                    shopping.setPrice(rs.getDouble("price"));
                    shopping.setImage(rs.getString("image"));
                    shopping.setStock(rs.getInt("stock"));
                    list.add(shopping);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    private void fill(PreparedStatement ps, Shopping shopping) throws SQLException {
        ps.setString(1, shopping.getSid());
        ps.setString(2, shopping.getSname());
        ps.setDouble(3, shopping.getPrice());
        ps.setString(4, shopping.getImage());
        ps.setInt(5, shopping.getStock());
    }
}

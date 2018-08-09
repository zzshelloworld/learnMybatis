package tk.mybatis.simple.type;

public class TestEnum {
    public static void main(String[] args) {
        System.out.println(Enabled.enabled.getValue());
        System.out.println(Enabled.values());
        // 枚举 头上值，相当于每个实例化类的对象。
        for (Enabled enabled : Enabled.values()) {
            System.out.println(enabled);
        }
    }
}

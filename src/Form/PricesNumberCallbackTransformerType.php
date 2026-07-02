<?php

namespace App\Form;

use App\Dto\PricesBcMathNumberDto;
use BcMath\Number;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\CallbackTransformer;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PricesNumberCallbackTransformerType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('priceA', NumberType::class)
            ->add('priceB', NumberType::class)
            ->add('priceC', NumberType::class)
            ->add('priceD', NumberType::class);

        // Avoid error: Unable to transform value for property path "priceX": Expected a numeric.
        $builder->get('priceA')->addModelTransformer(static::getCallbackTransformer());
        $builder->get('priceB')->addModelTransformer(static::getCallbackTransformer());
        $builder->get('priceC')->addModelTransformer(static::getCallbackTransformer());
        $builder->get('priceD')->addModelTransformer(static::getCallbackTransformer());
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PricesBcMathNumberDto::class]);
    }

    /**
     * DTO → Form: BcMath\Number → (transform) → float → (NumberType) → show string
     * Form → DTO: entered string → (NumberType) → float → (reverseTransform) → BcMath\Number.
     */
    private static function getCallbackTransformer(): CallbackTransformer
    {
        return new CallbackTransformer(
            fn (?Number $value): ?float => null === $value ? null : (float) (string) $value,
            fn (int|float|null $value): ?Number => null === $value ? null : new Number((string) $value),
        );
    }
}
